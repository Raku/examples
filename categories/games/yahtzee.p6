#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Yahtzee

=AUTHOR David Romano

Simulate rolling dice for the game of
L<Yahtzee|http://en.wikipedia.org/wiki/Yahtzee>.

=end pod

sub roll-dice { (1..6).roll($^rolls) };

sub round {
    my @roll = roll-dice(5);
    my $rolls = 1;
    repeat {
        say "Dice: { @roll }";
        my @dice = prompt("Which dice do you want to roll again (1-5)? ").split(/\s+/);
        if @dice[0] eq "" {
            $rolls = 3;
        }
        else {
            @roll[map { $^index - 1 }, @dice] = roll-dice(@dice.elems);
            $rolls++;
        }

    } until $rolls == 3;
    say "Which box?";
    map { say $^a.key ~ ".\t" ~ $^a.value }, (1 => 'Aces'), (2 => 'Twos');
    return @roll;
}

my @round = round;

# vim: expandtab shiftwidth=4 ft=perl6
