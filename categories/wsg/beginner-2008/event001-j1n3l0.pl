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

=begin pod

=head1 NAME

event001-j1n3l0.pl

=head1 USAGE

perl6 event001-j1n3l0.pl <cards>

=head1 NOTE

<cards> should be one of 2 .. 10, J, Q, K, A (though I don't check).

=end pod
