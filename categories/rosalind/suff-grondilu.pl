use v6;

=begin pod

=TITLE Encoding Suffix Trees

=AUTHOR L. Grondin

L<http://rosalind.info/problems/suff/>

Sample input

    ATAAATG$

Sample output

    AAATG$
    G$
    T
    ATG$
    TG$
    A
    A
    AAATG$
    G$
    T
    G$
    $

=end pod

sub suffixes(Str $str) { map *.flip, [\~] $str.flip.comb }
sub suffix-tree(@a) {
    @a == 0 ?? [] !!
    @a == 1 ?? hash @a[0] => [] !!
    hash gather for @a.classify(*.substr(0, 1)) {
        my $subtree = suffix-tree([ grep *.chars, map *.substr(1), .value[] ]);
        if $subtree.elems == 1 {
            my $pair = $subtree.pick;
            take .key ~ $pair.key => $pair.value;
        } else {
            take .key => $subtree;
        }
    }
}

sub show-edges($tree) {
    return if $tree.elems == 0;
    for $tree[] {
        say .key;
        show-edges .value;
    }
}

sub MAIN(Str $input = 'ATAAATG$') {
    show-edges suffix-tree suffixes $input;
}

# vim: expandtab shiftwidth=4 ft=perl6
