use v6;

my $term = 1;
my $last_term = 0;
my $sum = 0;

while ($term < 4000000) {
   ($last_term, $term) = ($term, $term + $last_term);
   $sum += $term unless $term % 2;
}
say "Total $sum";
