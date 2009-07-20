use v6;

sub is_prime ($num) {
   for (2..^$num) { 
      return 0 unless $num % $_;
   }
   return 1;
};

class Primes {
   has $.current = 0;
   
   method next {
     $!current++;
     $!current++ until is_prime($.current);
     return $.current;
   }
}

my $prime = Primes.new();
my $number = 600851475143;
while ($number > 1) {
   if !($number % $prime.next) {
     $number /= $prime.current;
     say "Found: ", $prime.current;
   }
}
