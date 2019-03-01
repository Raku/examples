#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Tic Tac Toe

=AUTHOR Philip Potter

From a silly discussion in #perl6...
See L<http://rhebus.posterous.com/learning-perl-6-by-playing-silly-games>
and feel free to add a further golfed refinement to the end

Specification:
Find out who won, if anyone, in a game of tic-tac-toe.

=end pod

sub tictactoe-masak (**@b) {
    my @lines = [0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6];
    for @lines {
        if ([==] (my @l = slicel(@b, $_))) && all @l {
            say "Someone won: @l[0]"
        }
    }
}

sub slicel(@a, @s) {
    map { @a[$_ div 3][$_ % 3] }, @s
}

tictactoe-masak([-1, 0, 0],
                [ 0,-1, 0],
                [ 0, 0,-1],
            );

sub tictactoe-rhebus (*@b) {
    my @lines = flat (0,3,6 X+ 0,1,2),(0,1,2 X+ 0,3,6),0,4,8,2,4,6;
    for @lines -> $a,$b,$c {
        if @b[$a] && [==] @b[$a,$b,$c] {
            say "@b[$a] won"
        }
    }
}

tictactoe-rhebus( 1, 1,-1,
                 -1,-1, 1,
                 -1, 0, 0);

sub tictactoe-moritz (*@b) {
    my @lines = flat (0,3,6 X+ ^3), (^3 X+ 0,3,6), 0,4,8,2,4,6;
    for @lines -> $a, $b, $c {
        if @b[$a] && [==] @b[$a,$b,$c] {
            say "@b[$a] won"
        }
    }
}

tictactoe-moritz( 1, 1, 1,
                  0,-1,-1,
                 -1,-1, 0);

sub tictactoe-rhebus2 (*@b) {
    my @lines = flat ^9,(^3 X+ 0,3,6),8,4,(^4 Z+ ^4);
    say ~@lines;
    for @lines -> $a, $b, $c {
        if @b[$a] && [==] @b[$a,$b,$c] {
            say "@b[$a] won"
        }
    }
}

tictactoe-rhebus2( 1, 1, 1,
                   0,-1,-1,
                  -1,-1, 0);

# vim: expandtab shiftwidth=4 ft=perl6
