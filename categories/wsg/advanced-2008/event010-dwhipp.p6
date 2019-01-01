use v6;

=begin pod

=TITLE Blackjack!

=AUTHOR David Whipp

In Blackjack! competitors must write a script that deals and plays a single
hand of Blackjack (Twenty-One).

Event Scenario

For the final event in the Advanced Division you must write a script that
can deal – and play – a single hand of Blackjack (also known as Twenty-One).
For the purposes of this event, we’ll be playing a simplified version of
Blackjack, one that features the following rules:

=item No betting is involved. (Sorry; maybe next year.)

=item All aces are worth 11 points. And yes, we know: in standard Blackjack,
      aces can be worth either 1 point or 11 points. For Event 10, however, aces
      will only be worth 11 points. (We don’t want to make this event too
      complicated.)

Oh, OK: if you want to you can make aces worth 1 or 11. But you don’t have
to do this unless you want to.

=item All face cards (Kings, Queens, Jacks) are worth 10 points.

=item All other cards are equal to their face value: the three of spades is
      worth 3 points, the 7 of diamonds is worth 7 points, etc.

=item Ties (pushes) go the dealer. Suppose, at the end of the hand, the player
      has 18 points and the dealer has 18 points. In that case, the dealer is
      declared the winner.

Your script should start by “shuffling” a standard deck of playing cards and
then dealing two cards to the player and two more to the dealer. (Not sure
what cards make up a ‘standard deck of playing cards?” Then click here for
more information.) As in regular blackjack, the two cards to the player
should be dealt “face up;” that is, both cards should be revealed:

    Your cards:
    Seven of Spades
    Eight of Spades

By contrast, only one of the dealer’s cards should be revealed:

    Dealer's cards:
    Ace of Hearts

Note. Notice that we specified the cards by name. Don’t just list card
values, like this:

    7
    8

That will cause your script to fail. Be specific when it comes to listing cards.

Again, following standard Blackjack rules, the player should be given the
option to stay (play the two cards he or she was dealt) or hit (be dealt
another card). In other words:

    Stay (s) or hit (h) ?

If the player chooses “hit,” then he or she should be dealt another card. If
the sum total of the three cards is more than 21, then the player
automatically loses:

    Stay (s) or hit (h) ?h
    Seven of Spades
    Eight of Spades
    Seven of Diamonds
    Over 21. Sorry, you lose.

If the sum total is 20 or less, then the player is given another opportunity
to hit or stay. (If the sum total is 21 the player wins.) As soon as the
player chooses to stay, the dealer (the computer) checks to see if its point
total exceeds that of the player. For example, suppose the player has the
seven of spades and the eight of spades; that means that the player has 15
points. Now suppose that the dealer has the ace of hearts and the six of
diamonds. That means that the dealer has 17 points (11 + 6), which also
means that the dealer automatically wins.

Now, suppose the player has 16 points and the dealer has 13. In that case,
the dealer must be dealt another card. Let’s examine some possibilities for
that next card:

=item The dealer is dealt a two, giving the dealer 15 points. That’s less than
      the player’s 16, so the dealer must go again.

=item The dealer is dealt a nine, giving it 22 points. 22 is more than 21, so
      the dealer loses.

=item The dealer is dealt a three, giving both the dealer and the player 16.
      Because ties go to the dealer, the dealer automatically wins.

A complete hand might play out something like this:

=begin code
Your cards:
King of Hearts
Seven of Hearts

Dealer's cards:
Nine of Hearts

Stay (s) or hit (h)?s

You have 17.

Dealer's cards:
Nine of Hearts
Seven of Diamonds

Dealers' cards:

Nine of Hearts
Seven of Diamonds
Five of Diamonds
The dealer has 21. Sorry, you lose.
=end code

See? That shouldn't be too terribly hard, especially not for anyone who made
it through the first nine events.

L<http://web.archive.org/web/20080406020248/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/aevent10.mspx>

=end pod

sub MAIN(Bool :$computer-player = False) {
    my $player_is_human = not $computer-player;

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

    my @deck = ( @values X @suites ).flat.map: {
        my ($name, $value) = $^a.kv;
        $name ~= " of $^b";
        $name => $value
    };

    my @cards = $computer-player ?? default-cards() !! @deck.pick( @deck.elems );

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
            say "congratulations, you win!";
            exit 0;
        }
        elsif $player_value < 21 {
            say "hit (h) or stay (s)";
            my $choice;
            if ($player_is_human) {
                loop {
                    $choice = lc $*IN.get;
                    last if $choice eq "h" | "s";
                    say "invalid entry: 'h' or 's'";
                }
            }
            else {
                $choice = $player_value < 16 ?? "hit" !! "stay";
            }
            say $choice;
            last if $choice ~~ /s/;
        }
        else {
            say "sorry, you bust!";
            exit 0;
        }
    }

    say "";

    $player_value = max (4 .. 21).grep: { $_ == $player_value };

    say "DEALER:";
    .key.say for @dealer;

    my $dealer_value = [+] @dealer.map: { .value };

    loop {
        say "dealer value: {$dealer_value.perl}";

        if $dealer_value == any( $player_value ^.. 21) {
            say "you lose!";
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
}

sub default-cards {
    return [
    "three of diamonds" => 3,
    "five of diamonds" => 5,
    "seven of diamonds" => 7,
    "ten of diamonds" => 10,
    "two of diamonds" => 2,
    "jack of spades" => 10,
    "five of clubs" => 5,
    "five of hearts" => 5,
    "eight of diamonds" => 8,
    "six of spades" => 6,
    "five of spades" => 5,
    "king of hearts" => 10,
    "nine of diamonds" => 9,
    "two of hearts" => 2,
    "king of clubs" => 10,
    "eight of clubs" => 8,
    "two of spades" => 2,
    "ace of hearts" => any(1, 11),
    "nine of hearts" => 9,
    "eight of spades" => 8,
    "jack of diamonds" => 10,
    "jack of hearts" => 10,
    "nine of clubs" => 9,
    "ten of hearts" => 10,
    "eight of hearts" => 8,
    "king of spades" => 10,
    "ace of spades" => any(1, 11),
    "queen of hearts" => 10,
    "nine of spades" => 9,
    "two of clubs" => 2,
    "queen of diamonds" => 10,
    "three of spades" => 3,
    "queen of clubs" => 10,
    "three of clubs" => 3,
    "ten of spades" => 10,
    "ace of clubs" => any(1, 11),
    "ace of diamonds" => any(1, 11),
    "four of hearts" => 4,
    "six of clubs" => 6,
    "ten of clubs" => 10,
    "seven of hearts" => 7,
    "king of diamonds" => 10,
    "four of diamonds" => 4,
    "seven of spades" => 7,
    "queen of spades" => 10,
    "four of spades" => 4,
    "six of hearts" => 6,
    "four of clubs" => 4,
    "seven of clubs" => 7,
    "six of diamonds" => 6,
    "three of hearts" => 3,
    "jack of clubs" => 10]<>;
}

# vim: expandtab shiftwidth=4 ft=perl6
