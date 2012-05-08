use v6;

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
