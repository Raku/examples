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

trie lines;

=END
use strict;
use warnings;
no warnings qw(recursion);

my $node = 1;

sub classify {
    my $f = shift;
    my %classif;
    for (@_) {
        $classif{$f->($_)} //= [];
        push $classif{$f->($_)}, $_;
    }
    \%classif;
}

sub trie {
    my @string = @{shift()};
    my $root = shift // $node;
    return +{} if not @string;
    my %trie;
    my %classify = %{ classify sub { substr shift, 0, 1 }, @string };
    for my $key (keys %classify) {
        my @value = map { substr $_, 1 } grep { length > 1 } @{$classify{$key}};
        printf "%i %i %s\n", $root, ++$node, $key;
        $trie{$key} = trie( [ @value ], $node ) if @value;
    }
    return \%trie;
}

trie [ map { chomp; $_ } <> ];
__END__
trie [ qw(ATAGA ATC GAT) ];

__END__

# vim: ft=perl6
