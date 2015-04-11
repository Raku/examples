use v6;

=begin pod

=TITLE Pairing off

=AUTHOR Nelo Onyiah

In Pairing Off, competitors will be given a series of five playing cards and
asked to determine the number of pairs.

Event Scenario

This is one of the less-complicated events, both to explain and to perform.
In this event we'll be working with a standard deck of playing cards. A
standard deck consists of four suits: Hearts, Spades, Clubs, and Diamonds.
Within each suit are the numbers two through ten, plus a Jack, a Queen, a
King, and an Ace.

Given a random set of five cards, your task is to find out how many pairs
are in that set. In other words, if your five cards are the 2 of hearts, the
4 of spades, the 4 of clubs, the queen of diamonds and the queen of spades,
you have 2 pairs: 2 fours and 2 queens. As another example, you might have a
3 of clubs, a 3 of diamonds, a 3 of hearts, a 10 of spades and an ace of
hearts. In that case you have 3 pairs: 3 of clubs and 3 of diamonds; 3 of
diamonds and 3 of hearts; and 3 of clubs and 3 of hearts.

For this event you should assume you've been dealt the following five cards:

=item Seven of spades
=item Five of hearts
=item Seven of diamonds
=item Seven of clubs
=item King of clubs

Using this set of cards, your script should display the number of pairs.
Keep in mind that we will look at the scripts as we test them. A script that
simply displays the number 3 will receive a score of 0; you actually have to
do the calculations based on these cards. Not only that, but it shouldn't
matter what the cards are: if we substitute any other set of five cards your
script should still return the correct number of pairs.

L<http://web.archive.org/web/20080218182214/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent1.mspx>

=head1 USAGE

    $ perl6 event001-j1n3l0.pl <cards>

=head1 NOTE

<cards> should be one of 2 .. 10, J, Q, K, A (though I don't check).

=end pod

my @default-cards = qw{7 5 7 7 K};
sub MAIN(@cards = @default-cards) {
    my $pairs = 0;
    repeat {
        my $card = @cards.shift;
        for @cards -> $other_card {
            $pairs++ if $card eq $other_card;
        }
    } until @cards.elems == 0;
    say 'Total: ' ~ $pairs;
}

# vim: expandtab shiftwidth=4 ft=perl6
