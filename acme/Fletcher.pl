
# Example: Foo::Bar-auth:92de-ver:1.2.0
 #((
	my $filename = urlencode($module);
	for %metadata.sort.kv -> $k,$v {
		$v = $v ~~ m/[\D & <-[.]>]/ ?? $v !! Fletcher16($v);
		$filename ~= "-$k:$v";
	}
 ))

say Fletcher16("動物");

sub Fletcher16($str) {
	my ($A,$B) = (0,0);
	for map { .ord }, $str.split('') -> $val {
		$A = ($A + $val % 255) % 255;
		$B = ($B + $A) % 255;
		
		if $val > 255 {
			$A = ($A + int $val/255) % 255;
			$B = ($B + $A) % 255;
		}
	}
	return int2hex($A*256 + $B);
}

sub int2hex($val is rw) {
	my $hex = '';
	while $val {
		my $tmp = $val % 16;
		$val = ($val - $tmp) / 16;
		$hex ~= $tmp < 10 ?? $tmp !! chr (97 - 10 + $tmp);
	}
	return $hex;
}

