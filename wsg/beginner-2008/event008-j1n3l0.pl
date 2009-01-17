use v6;

my $number  = (1..50).pick(1).shift;
my $guesses = 0;

loop {
  print "Enter a number between 1 and 50: ";

  my $guess = =$*IN;

  unless $guess ~~ /^ \d+ $/ && 1 <= $guess <= 50 {
    warn "Invalid input ($guess).";
    next;
  }

  $guesses++;

  if $guess == $number {
    say "Got it in $guesses guess(es)!";
    last;
  }
  elsif $guess  > $number { say 'Too high' }
  elsif $guess  < $number { say 'Too low'  }
}
