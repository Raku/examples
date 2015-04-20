use v6;

=begin pod

=TITLE Calculating Expected Offspring

=AUTHOR L. Grondin

L<http://rosalind.info/problems/iev/>

Sample input

    1 0 0 1 0 1

Sample output

    3.5

=end pod

sub MAIN(Str $default-data = "1 0 0 1 0 1") {
    say 2 * [+] <1 1 1 3/4 1/2 0> Z* $default-data.split: " ";
}

# vim: expandtab shiftwidth=4 ft=perl6
