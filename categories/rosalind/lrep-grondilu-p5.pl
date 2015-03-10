#!/usr/bin/perl
use strict;
use warnings;

# parsing data
my $dna = <DATA>;
my $k = <DATA>;
my @edge = map [ split / +/ ], <DATA>;

# enumerating nodes
my %node; for my $edge (@edge) { $node{$edge->[$_]}++ for 0, 1 }
my @node = keys %node;

# enumerating parents
my %parent; $parent{$_->[1]} = $_->[0] for @edge;

# building tree-like structure
my $tree = {};
$tree->{$_->[0]}{$_->[1]} = [ @$_[2, 3] ] for @edge;

sub count_offspring {
    my $node = shift;
    return 1 unless keys %{$tree->{$node}};
    my $count;
    $count += count_offspring($_) for keys %{$tree->{$node}};
    return $count;
}

sub build_substr {
    my $node = shift;
    my $substr = '';
    while (exists $parent{$node}) {
        my $il = $tree->{$parent{$node}}{$node};
        $substr = substr($dna, $$il[0]-1, $$il[1]) . $substr;
        $node = $parent{$node};
    }
    return $substr;
}

my $found = '';
for my $node (@node) {
    my $count = count_offspring $node;
    if ($count >= $k) {
        my $substr = build_substr $node;
        $found = $substr if length($substr) > length($found);
    }
}
print "$found\n";


__DATA__
CATACATAC$
2
node1 node2 1 1
node1 node7 2 1
node1 node14 3 3
node1 node17 10 1
node2 node3 2 4
node2 node6 10 1
node3 node4 6 5
node3 node5 10 1
node7 node8 3 3
node7 node11 5 1
node8 node9 6 5
node8 node10 10 1
node11 node12 6 5
node11 node13 10 1
node14 node15 6 5
node14 node16 10 1
