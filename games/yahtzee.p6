#!/usr/bin/env perl6

sub roll-dice { map { (1..6).pick }, 1..$^rolls };

sub round {
    my @roll = roll-dice(5);
    my $rolls = 1;
    repeat {
        say "Dice: { @roll }";
        print q{Which dice do you want to roll again (1-5)? };
        my @dice = split(/\s+/, =$*IN);
        if "{@dice}" eq "" { $rolls = 3 } # XXX: why doesn't ! @dice.elems work?
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
# vim: ft=perl6
