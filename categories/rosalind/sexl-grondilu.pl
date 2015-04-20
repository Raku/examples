use v6;

=begin pod

=TITLE Sex-Linked Inheritance

=AUTHOR L. Grondin

L<http://rosalind.info/problems/sexl/>

Sample input

    0.1 0.5 0.8

Sample output

    0.18 0.5 0.32

=end pod

sub MAIN(Str $input = "0.1 0.5 0.8") {
    say map { 2*$^x*(1-$x) }, $input.split(' ')».Num;
}

# vim: expandtab shiftwidth=4 ft=perl6
