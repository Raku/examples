use v6;

my $num = (1..50).pick[0];
my $guesses = 0;
my $guess = 0;


loop {
	say "Pick a number between 1 and 50";
	$guesses++;
	$guess = =$*IN;
	given $guess {
  	 when $num { 
	 	say "You guessed correctly in {$guesses} guesses!";
		last; 
	 };
 	 when $_ < $num {say "You guessed too low."};
	 when $_ > $num {say "You guessed too high."};
	}
}	
