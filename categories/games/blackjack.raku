#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Blackjack

=AUTHOR David Whipp

Play Blackjack (a.k.a. 21) just like in a casino.

=head1 USAGE

    perl6 blackjack.p6

=end pod

my $player_is_human = 1;

my @values = (
    ace => 1|11,
    two => 2,
    three => 3,
    four => 4,
    five => 5,
    six => 6,
    seven => 7,
    eight => 8,
    nine => 9,
    ten => 10,
    jack => 10,
    queen => 10,
    king => 10,
);

my @suites = < spades clubs diamonds hearts >;

my @deck = flat( @values X @suites ).map: { my ($name, $value) = $^a.kv; $name ~= " of $^b"; $name => $value };

my @cards = @deck.pick( @deck.elems );

my @dealer;
my @player;

@dealer.push( @cards.shift );
@player.push( @cards.shift );
@dealer.push( @cards.shift );

say "DEALER:";
say @dealer[0].key;
say "";

say "PLAYER:";
.key.say for @player;

my $player_value = [+] @player.map: { .value };

loop {
    my $card = @cards.shift;

    @player.push( $card );
    say $card.key;

    $player_value += $card.value;

    say "current value is { $player_value.perl }";

    if $player_value == 21 {
        say "congradulations, you win!";
        exit 0;
    }
    elsif $player_value < 21 {
        say "hit (h) or stay (s)";
        my $choice;
        if ($player_is_human) {
            loop {
                $choice = lc $*IN.get;
                last if $choice eq "h" | "s";
                #last if $choice ~~ /h|s/;
                say "invalid entry: 'h' or 's'";
            }
        }
        else {
            $choice = "stay" unless $player_value < 16;
        }
        say $choice;
        last if $choice ~~ /s/;
    }
    else {
        say "Sorry, you bust!";
        exit 0;
    }
}

say "";

$player_value = [max] (4 .. 21).grep: { $_ == $player_value };

say "DEALER:";
.key.say for @dealer;

my $dealer_value = [+] @dealer.map: { .value };

loop {
    say "dealer value: {$dealer_value.perl}";

    if $dealer_value == any( $player_value ^.. 21) {
        say "you loose!";
        exit 0;
    }
    elsif $dealer_value < 21 {
        my $card = @cards.shift;
        @dealer.push( $card );
        say $card.key;
        $dealer_value += $card.value;
    }
    else {
        say "dealer bust: you win!";
        exit 0;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
