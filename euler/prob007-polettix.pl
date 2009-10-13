# By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13,
# we can see that the 6th prime is 13.
# 
# What is the 10001st prime number?

use v6;

# The number of prime we want, defaults to challenge's request
my $nth = shift(@*ARGS) || 10001;

# A simple implementation of Eratosthenes' sieve
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
         %D{$x} = $p;
         ++$q;
      }
      %D{$q * $q} = $q;
      return $q++;
   }
}

my $it = primes_iterator();
for 1 .. $nth - 1 -> $i {
   $it();
   say "found $i primes so far" unless $i % 100;
}
say 'result: ', $it();
