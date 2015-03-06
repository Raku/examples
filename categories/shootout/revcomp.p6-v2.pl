use v6;

=begin pod

=TITLE Read DNA sequences and write their reverse-complement

=AUTHOR

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=revcomp>

=end pod

my %trans = 'wsatugcyrkmbdhvnATUGCYRKMBDHVN'.comb Z=>
    'WSTAACGRYMKVHDBNTAACGRYMKVHDBN'.comb;

my ($desc, @seq);

for lines() {
    dump, $desc = $_, next if /^ \>/;
    @seq.unshift(.comb.reverse.map({ %trans{$^c} // $^c }));
    LAST dump;
}

sub dump {
    LEAVE @seq = Nil;
    return unless $desc.defined;

    @seq.splice($_, 0, "\n")
        for (60, 120 ...^ * >= +@seq).reverse;

    say $desc, "\n", @seq.join;
}

# vim: expandtab shiftwidth=4 ft=perl6
