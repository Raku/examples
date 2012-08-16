#!/usr/bin/env perl6
use v6;

sub rotate(@list is copy, $places is copy)
{
    $places < 0 ?? $places = @list.elems + $places !! ();

    for ^$places {
        @list.push: @list.shift;
    }

    @list
}

say rotate(<a b c d e f g>.list, 3).perl;
say rotate(<a b c d e f g>.list, -3).perl;

=begin pod

=head1 NAME

P19 - Rotate a list C<n> places to the left.

=end pod

# vim: ft=perl6
