use v6;

=begin pod

=TITLE Get list of files matching a pattern

=AUTHOR stmuk

You want a list of filenames matching a pattern

=end pod

my @perl-files = dir "." , test=>/\.pl/;

#  returns a list of IO::Path objects

for @perl-files -> $io {
    say $io.basename;
}

# vim: expandtab shiftwidth=4 ft=perl6
