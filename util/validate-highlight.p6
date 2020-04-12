#!/usr/bin/env raku
use Raku::Highlight;
use Terminal::Spinners;

sub MAIN($dir = 'categories') {
    my %results;
    my @examples;
    if 'cache'.IO.e {
        @examples = split "\n", slurp 'cache';
    } else {
        @examples = create-cache($dir);
    }

    sub bail-out() {
        my IO::Handle $cache = open :w, 'cache';
        say "Writing results...";
        my $hash-bar = Bar.new;
        $hash-bar.show: 0;
        for @examples.kv -> $i, $example {
            $hash-bar.show: $i / @examples.elems * 100;
            my ($path, $status) = $example.split('=');
            with %results{$path} {
                $cache.say("$path=$_");
            } else {
                $cache.say("$path=UNKNOWN");
            }
        }
        $cache.close;
        say "Done!";
        exit 0;
    }

    my $hash-bar = Bar.new;
    $hash-bar.show: 0;
    for @examples.kv -> $i, $example {
        $hash-bar.show: $i / @examples.elems * 100;
        my ($path, $status) = $example.split('=');
        given $status {
            when 'UNKNOWN'|'FAIL' {
                if (check-status($path) eq 'OK') {
                    %results{$path} = 'OK';
                    say "\n$path - oki! Good job!";
                } else {
                    %results{$path} = 'FAIL';
                    say "\nToo bad, need one more round for $path";
                    bail-out;
                }
            }
            when 'OK' {
                %results{$path} = 'OK';
                say "\n$path - oki! Good job!";
            }
        }
    }
    bail-out;
}

sub check-status($path) {
    my $text = slurp $path;
    try Raku::Highlight.highlight($text);
    return 'OK' without $!;
    warn $!;
    'FAIL';
}

sub create-cache($dir) {
    my @files;
    my @todo = $dir.IO;
    while @todo {
        for @todo.pop.dir -> $path {
            @files.push: "$path.Str()=UNKNOWN" unless $path.d;
            @todo.push: $path if $path.d;
        }
    }
    @files;
}