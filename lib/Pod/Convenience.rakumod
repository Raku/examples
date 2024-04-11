unit module Pod::Convenience;

sub pod-gist(Pod::Block $pod, $level = 0) is export {
    my $leading = ' ' x $level;
    my %confs;
    my @chunks;
    for <config name level caption type> {
        my $thing = $pod.?"$_"();
        if $thing {
            %confs{$_} = $thing ~~ Iterable ?? $thing.perl !! $thing.Str;
        }
    }
    @chunks = $leading, $pod.^name, (%confs.perl if %confs), "\n";
    for $pod.contents.list -> $c {
        if $c ~~ Pod::Block {
            @chunks.push: pod-gist($c, $level + 2);
        }
        elsif $c ~~ Str {
            @chunks.push: $c.indent($level + 2), "\n";
        }
        elsif $c ~~ Positional {
            @chunks.push: $c.map: {
                if $_ ~~ Pod::Block {
                    *.&pod-gist
                }
                elsif $_ ~~ Str {
                    $_
                }
            }
        }
    }
    @chunks.join;
}

sub first-code-block(@pod) is export {
    if @pod[1] ~~ Pod::Block::Code {
        return @pod[1].contents.grep(Str).join;
    }
    '';
}

sub pod-with-title($title, *@blocks) is export {
    Pod::Block::Named.new(
        name => "pod",
        contents => [
            pod-title($title),
            @blocks.flat,
        ]
    );
}

sub pod-title($title) is export {
    Pod::Block::Named.new(
        name    => "TITLE",
        contents => Array.new(
            Pod::Block::Para.new(
                contents => [$title],
            )
        )
    )
}

sub pod-block(*@contents) is export {
    Pod::Block::Para.new(:@contents);
}

sub pod-link($text, $url) is export {
    Pod::FormattingCode.new(
        type     => 'L',
        contents => [$text],
        meta     => [$url],
    );
}

sub pod-bold($text) is export {
    Pod::FormattingCode.new(
        type     => 'B',
        contents => [$text],
    );
}

sub pod-item(*@contents, :$level = 1) is export {
    Pod::Item.new(
        :$level,
        :@contents,
    );
}

sub pod-heading($name, :$level = 1) is export {
    Pod::Heading.new(
        :$level,
        :contents[pod-block($name)],
    );
}

sub pod-table(@contents, :@headers) is export {
    Pod::Block::Table.new(
        :@contents, :@headers
    )
}

sub pod-lower-headings(@content, :$to = 1) is export {
    my $by = @content.first(Pod::Heading).level;
    return @content unless $by > $to;
    my @new-content;
    for @content {
        @new-content.push($_ ~~ Pod::Heading
            ?? ( Pod::Heading.new :level(.level - $by + $to) :contents[.contents] )
            !! $_
        );
    }
    @new-content;
}

sub pod-code(@contents) is export {
    return Pod::Block::Code.new(contents => @contents);
}

sub pod-title-contents($pod, $file) is export {
    my $title-element = $pod[0].contents[0];
    my $title = "";
    if $title-element ~~ Pod::Block::Named && $title-element.name eq "TITLE" {
        try {
            $title = $title-element.contents[0].contents[0];
            CATCH {
                default { $title = "TITLE is empty" }
            }
        }
    }
    else {
        say "$file lacks a TITLE";
    }

    return $title;
}

sub pod-author-contents($pod, $file) is export {
    my $author-element = $pod[0].contents[1];
    my $author = "";
    if $author-element ~~ Pod::Block::Named && $author-element.name eq "AUTHOR" {
        try {
            $author = $author-element.contents[0].contents[0];
            CATCH {
                default { $author = "AUTHOR is empty" }
            }
        }
    }
    else {
        say "$file lacks an AUTHOR";
    }

    return $author;
}

sub format-author-heading($example) is export {
    my $pod = $example.pod-contents;
    if $example.author {
        my $author-heading = Pod::FormattingCode.new(:type<I>,
                                contents => ["Author: " ~ $example.author]);
        $example.pod-contents[0].contents[1] = pod-block([$author-heading]);
    }

    return $pod;
}

sub source-reference($file, $category-name, $base-category-dir) is export {
    my $base-github-url = "https://github.com/perl6/perl6-examples/blob/master";
    my $filename = $file.basename;
    pod-block("Source code: ",
        pod-link($filename,
            "$base-github-url/$base-category-dir/$category-name/$filename"),
    );
}

sub source-without-pod($file) is export {
    my $example-source = slurp $file;
    $example-source.=subst(rx:s/\=begin pod.*\=end pod/, '');
    $example-source.=subst(rx/^^'# vim:'.*$$/, '');
    $example-source.=subst(rx/\n ** 3..*/, "\n\n");

    return pod-code([$example-source]);
}

# vim: expandtab shiftwidth=4 ft=perl6
