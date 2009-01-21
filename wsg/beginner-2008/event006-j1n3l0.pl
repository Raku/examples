use v6;

our %count_for;

sub MAIN(Str $orders = 'coffee.txt') {
  # get the data
  my $handle   = open $orders;
  my @contents = =$handle;

  $handle.close;

  # count the orders
  for @contents -> $line {
    unless $line ~~ /^ (Office \s+ \d+) $/ {
      my ($drink, $count) = $line.split(/\s+/);
      %count_for{$drink} += $count;
    }
  }

  # print to screen
  for %count_for.kv -> $drink, $total {
    say $drink ~ ": " ~ $total;
  }
}

#  my @contents = slurp($orders); xxx: does not work with chomp
