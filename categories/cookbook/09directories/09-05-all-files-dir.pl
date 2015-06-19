use v6;

=begin pod

=TITLE Process all files in a directory

=AUTHOR stmuk

You want to process all files in a directory

=end pod

sub MAIN(:$dir = ".") {
    # print Perl's representation of each file
    for dir($dir).sort -> $file {
        say $file.perl;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
