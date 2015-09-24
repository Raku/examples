use v6;

=begin pod

=TITLE Mendel's First Law

=AUTHOR L. Grondin

L<http://rosalind.info/problems/iprb/>

Sample input

    2 2 2

Sample output

    0.78333

=end pod

sub take-two($n) { $n*($n-1)/2 }

sub MAIN(Str $input = "2 2 2") {
    given $input.split: " " {
        say
        take-two([+] .[].cache) R/ (
            [+]
            take-two(.[0])       ,   # two homozygous dominant
            3/4 * take-two(.[1]) ,   # two heterozygous
            .[0] * .[1]          ,   # one homozygous dominant and one heterozygous
            .[0] * .[2]          ,   # one homozygous dominant and one homozygous recessive
            1/2 * .[1] * .[2]    ,   # one heterozygous and one homozygous recessive
        )
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
