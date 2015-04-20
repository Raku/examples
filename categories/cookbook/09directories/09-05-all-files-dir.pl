use v6;

=begin pod

=TITLE Process all files in a directory

=AUTHOR stmuk

You want to process all files in a directory

=end pod

for  dir(".") -> $f {
    say $f.perl;
}

# vim: expandtab shiftwidth=4 ft=perl6
