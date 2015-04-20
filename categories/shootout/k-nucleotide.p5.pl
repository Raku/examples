#  The Computer Language Benchmarks Game
#  http://shootout.alioth.debian.org/
#  contributed by Karl FORNER
# (borrowed fasta loading routine from Kjetil Skotheim, 2005-11-29)
# Corrected again by Jesse Millikan
# revised by Kuang-che Wu

my ($sequence);
$/ = ">";
/^THREE/ and $sequence = uc(join "", grep !/^THREE/, split /\n+/) while
<STDIN>;

my ($l,%h,$sum) = (length $sequence);
foreach my $frame (1,2) {
  %h = ();
  update_hash_for_frame($frame);
  $sum = $l - $frame + 1;
  printf "$_ %.3f\n", $h{$_}*100/$sum for sort { $h{$b} <=> $h{$a} || $a
cmp $b } keys %h;
  print "\n";
}

foreach my $s (qw(GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT)) {
  update_hash_for_frame(length($s));
  printf "%d\t$s\n", $h{$s};
}

sub update_hash_for_frame {
  my $frame = $_[0];
  $h{substr($sequence,$_,$frame)}++ foreach (0..($l - $frame));
}

