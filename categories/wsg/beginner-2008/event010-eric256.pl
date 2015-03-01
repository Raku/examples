use v6;

my @frames = <2 5 7 / 8 1 X 9 / 5 3 7 0 4 5 X 2 0>;
my @pins;

for @frames {
	if $_ eq '/' {


my $score = 0;

sub score ($ball) {
   return 10  if  $ball eq 'X';
   return $ball;
};

while (@frames) {
	my $frame = @frames.shift;
	last unless defined $frame;
	say "checking $frame";
	given $frame {
		when '/' { 
			$score += 10 + score(@frames[1]);
		}
		when 'X' { 	
 		    if (@frames[1,2] ~~ (*, '/')) {
			    $score += 20;
			} else {
				$score += 10 + score(@frames[1]) + score(@frames[2]);
			}
		}
		when '0'..'9' { 
			if (@frames.elems > 0) {
				$score += $frame unless defined @frames[1] eq '/' 
			} else {
				$score += $frame;
			}
		}
 	}

}
say "$score";
