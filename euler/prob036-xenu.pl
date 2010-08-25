#
# it's very slow, it took several hours to complete on Intel Core i7 920
# DON'T TRY  EXECUTING THIS SCRIPT WITH RAKUDO 2010.08 OR OLDER! 
# Because of memory leak in these versions, this code eats tens of gigabytes of RAM
#

my $palindromNumbersSum = 0;
loop (my $i = 1; $i <= 999999; $i+=2) {
	if ( ($i.flip == $i) && (sprintf('%b',$i).flip == sprintf('%b',$i)) ) {
		$palindromNumbersSum += $i;
	}
	# uncomment that if you want to see progress
	#if ($i%999 == 0) {
	#	say $i;
	#}
}
say $palindromNumbersSum;
