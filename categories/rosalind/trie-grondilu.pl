use v6;

=begin pod

=TITLE Introduction to Pattern Matching

=AUTHOR L. Grondin

=head2 Problem

Given a collection of strings, their trie (often pronounced "try" to avoid
ambiguity with the general term tree) is a rooted tree formed as follows.
For every unique first symbol in the strings, an edge is formed connecting
the root to a new vertex. This symbol is then used to label the edge.

We may then iterate the process by moving down one level as follows. Say
that an edge connecting the root to a node I<v> is labeled with 'A'; then we
delete the first symbol from every string in the collection beginning with
'A' and then treat I<v> as our root. We apply this process to all nodes that
are adjacent to the root, and then we move down another level and continue.
See Figure 1 for an example of a trie.

As a result of this method of construction, the symbols along the edges of
any path in the trie from the root to a leaf will spell out a unique string
from the collection, as long as no string is a prefix of another in the
collection (this would cause the first string to be encoded as a path
terminating at an internal node).

Given: A list of at most 100 DNA strings of length at most 100 bp, none of
which is a prefix of another.

Return: The adjacency list corresponding to the trie I<T> for these
patterns, in the following format. If I<T> has I<n> nodes, first label the
root with 1 and then label the remaining nodes with the integers 2 through
I<n> in any order you like. Each edge of the adjacency list of I<T> will be
encoded by a triple containing the integer representing the edge's parent
node, followed by the integer representing the edge's child node, and
finally the symbol labeling the edge.

L<http://rosalind.info/problems/trie/>

=head2 Sample dataset:

    ATAGA
    ATC
    GAT

=head2 Sample output:

    1 2 A
    2 3 T
    3 4 A
    4 5 G
    5 6 A
    3 7 C
    1 8 G
    8 9 A
    9 10 T

=head2 Usage:

    $ perl6 trie-grondilu.pl

or

    $ perl6 trie-grondilu.pl --data="GAT ATC"

=end pod

my Int $node = 1;

sub trie(@string is copy, $root = $node) {
    @string .= grep: *.chars;
    return {} if not @string;
    hash gather for @string.classify(*.substr: 0, 1).sort(*.key)>>.kv -> ($k, $v) {
        my @value = map *.substr(1), grep *.chars > 1, $v[];
        say "$root {++$node} $k";
        if (@value) {
            take $k => &?ROUTINE( @value, $node );
        }
    }
}

sub MAIN(:$data = "ATAGA ATC GAT") {
    my @input = $data.split(/\s+/);
    trie @input;
}

# vim: expandtab shiftwidth=4 ft=perl6
