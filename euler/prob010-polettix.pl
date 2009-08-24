# The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
# 
# Find the sum of all the primes below two million.

use v6;

# The upper bound, defaults to challenge's request
my $upper_bound = shift(@*ARGS) || 2_000_000;

# A simple implementation of Eratosthenes' sieve. Modified to avoid
# registering stuff beyond the $upper_bound.
sub primes_iterator {
   return sub {
      state %D;
      state $q //= 2;
      while (%D.exists($q)) {
         my $p = %D.delete($q);

         # As of Aug. 13, 2009 rakudo insists on giving back an Array()
         # from .delete, so we have to work it around
         $p = $p.pop if $p.WHAT eq 'Array()';

         my $x = $q + $p;
         $x += $p while %D.exists($x);
         %D{$x} = $p if $x <= $upper_bound;
         ++$q;
      }
      my $q2 = $q * $q;
      %D{$q2} = $q if $q2 <= $upper_bound;
      return $q++;
   }
}

my $it = primes_iterator();
my $prime = $it();
my $sum = 0;
my $feedback_threshold = 0; # To give some life signals during computation...
while $prime < $upper_bound {
   $sum += $prime;
   if $prime > $feedback_threshold {
      say $prime;
      $feedback_threshold += 1000;
   }
   $prime = $it();
}
say 'result: ', $sum;
