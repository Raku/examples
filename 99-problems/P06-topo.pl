#!/usr/bin/env perl6
use v6;

sub palindromic(@list)
{
    @list ~~ @list.reverse;
}

sub palindromic_short(@list) {
    if @list.elems < 2 {
	return True;
    }
    my $start = 0;
    my $end = @list.elems - 1;
    my $mid_start = floor(@list.elems / 2 - 1);
    my $mid_end = ceiling(@list.elems / 2);
    @list[$start .. $mid_start] ~~ @list[$mid_end .. $end].reverse;
}

my @functions = (&palindromic, &palindromic_short);
my @examples = [
    [[< a b c d E >], False],
    [[< a b c b a >], True],
    [[< a b b E >], False],
    [[< E b b a>], False],
    [[< a b b a >], True],
    [[< a >], True],
    [[< a a >], True],
    [[< E a >], False] ].lol;

for @examples -> ($list, $result) {
    for @functions -> $f {
	if $f($list) != $result {
	    die "{$f}({$list.perl}) expect $result, but {$f($list).perl}";
	}
    }
}

=begin pod

=head1 NAME

P06 - Find out whether a list is a palindrome.

=end pod

# vim: expandtab shiftwidth=4 ft=perl6
