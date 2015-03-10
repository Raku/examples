use v6;

=begin pod

=TITLE Pairing off

=AUTHOR Nelo Onyiah

=head1 USAGE

    $ perl6 event001-j1n3l0.pl <cards>

=head1 NOTE

<cards> should be one of 2 .. 10, J, Q, K, A (though I don't check).

L<http://web.archive.org/web/20080324231941/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent1.mspx>

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
