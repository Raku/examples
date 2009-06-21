use v6;

my $count = 0;
for 1..9 -> $x {
    for 1..200 -> $y {
        if ($x**$y).chars == $y {
            say "$x**$y";
            $count++;
        }
    }
}
say $count;
say "missing bigint support: answer should be 49";
