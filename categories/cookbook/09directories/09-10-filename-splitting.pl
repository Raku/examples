use v6;

=begin pod

=TITLE Splitting a filename up

=AUTHOR stmuk

You want to split a filename into basename, directory etc.

=end pod

my $io = IO::Path.new-from-absolute-path("/usr/lib64/libc.so");

say $io.basename;
say $io.dirname;;
say $io.extension;

# vim: expandtab shiftwidth=4 ft=perl6
