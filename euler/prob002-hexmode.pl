#!perl6

# code exposes a bug in r34733 rakudo, but works in pugs

class Fibonacci {
  has @!list is rw = (0, 1);

  method next() {
    @!list[2] = [+] @!list;
    shift @!list;
    return @!list[1];
  }
}

my $fibber = Fibonacci.new;
my $f;

my @r = gather {
  $f = $fibber.next;
  while $f < 4000000 {
    take (0+$f) if $f % 2 == 0;
    $f = $fibber.next;
  }
}
say @r.join(",");
say [+] @r;
