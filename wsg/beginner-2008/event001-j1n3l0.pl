use v6;
our $pairs;
sub MAIN(*@cards) {
  repeat {
    my $card = @cards.shift;
    for @cards -> $other_card {
      $pairs++ if $card eq $other_card;
    }
  } until @cards.elems == 0;
  say 'Total: ' ~ $pairs;
}
