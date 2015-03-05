use v6;

=begin pod

=TITLE Maximum Matchings and RNA Secondary Structures

=AUTHOR grondilu

L<http://rosalind.info/problems/mmch/>

Sample input

    >Rosalind_92
    AUGCUUC

Sample output

    6

=end pod

sub C($k, $n) {
   if $k < 0 or $k > $n { return 0 }
   elsif $k < 2 { return $n }
   elsif $k == $n { return 1 }
   else {
       return (state @)[$n][$k] //= C($k-1, $n-1) + C($k, $n-1)
   }
}

sub postfix:<!>(Int $n) { [*] 1 .. $n }

my $rna = lines[1..*-1].join;
given $rna.comb.bag {
    say
    C(.<A U>.min, .<A U>.max) * .<A U>.min!  *
    C(.<C G>.min, .<C G>.max) * .<C G>.min!;
}

# vim: expandtab shiftwidth=4 ft=perl6
