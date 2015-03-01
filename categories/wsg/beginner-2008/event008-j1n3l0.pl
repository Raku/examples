use v6;

our $number  = (1..50).pick(1).shift;
our $guesses = 0;

sub prompt(Str $text) {
  print $text;
  return =$*IN; # it would be nice to do something like Int $input = =$*IN;
}

sub is_valid($guess) {
    unless $guess ~~ /^ \d+ $/ && 1 <= $guess <= 50 {
      warn "Invalid input ($guess).";
      return;
    }
    return $guess;
}

sub MAIN() {
  loop {
    my $guess = prompt "Enter a number between 1 and 50: ";

    next unless is_valid $guess;

    $guesses++;

    if $guess == $number {
      say "Got it in $guesses guess(es)!";
      last;
    }
    elsif $guess  > $number { say 'Too high' }
    elsif $guess  < $number { say 'Too low'  }
  }
}
