use v6;

# brute force

#sub postfix:<!>($n) is cached { return [*] 1..$n }
sub postfix:<!>($n) { return [*] 1..$n }

sub infix:<C>($n,$r)  { $n! / ($r! * ($n-$r)!); }

my $count = 0;
for 1..100 -> $n {
    for 1..$n -> $r {
        $count++  if $n C $r > 1_000_000;
    }
}
say $count;
