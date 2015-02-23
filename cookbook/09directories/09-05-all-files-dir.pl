use v6;

=begin pod

=head1 Process all files in a directory

You want to process all files in a directory 

=end pod

for  dir(".") -> $f {
    say $f.perl;
}


# vim: ft=perl6
