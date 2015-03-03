use v6;

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

sub MAIN(@input = qw{ATAGA ATC GAT}) {
    trie @input;
}

# vim: expandtab shiftwidth=4 ft=perl6
