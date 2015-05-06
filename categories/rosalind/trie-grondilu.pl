use v6;

=begin pod

=TITLE Introduction to Pattern Matching

=AUTHOR L. Grondin

L<http://rosalind.info/problems/trie/>

Sample dataset:

    ATAGA
    ATC
    GAT

Sample output:

    1 2 A
    2 3 T
    3 4 A
    4 5 G
    5 6 A
    3 7 C
    1 8 G
    8 9 A
    9 10 T

Usage:

    $ perl6 trie-grondilu.pl

or

    $ perl6 trie-grondilu.pl --data="GAT ATC"

=end pod

my Int $node = 1;

sub trie(@string is copy, $root = $node) {
    @string .= grep: *.chars;
    return {} if not @string;
    hash gather for @string.classify(*.substr: 0, 1).kv -> $k, $v {
        my @value = map *.substr(1), grep *.chars > 1, $v[];
        say "$root {++$node} $k";
        take $k => &?ROUTINE( @value, $node ) if @value;
    }
}

sub MAIN(:$data = "ATAGA ATC GAT") {
    my @input = $data.split(/\s+/);
    trie @input;
}

# vim: expandtab shiftwidth=4 ft=perl6
