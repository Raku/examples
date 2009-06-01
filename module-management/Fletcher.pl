# A sketch program to compute unique file names for Perl modules based
# on the Fletcher-16 hash.
# 
# Author: Daniel Carrera
# License: Public Domain
# 
# Example: Foo::Bar-auth:92de-ver:1.2.0--0
# 
# Explanation:
# 		The module name (Foo::Bar) is URL-encoded. After that, we add all
#		metadata sorted by key. Version numbers are left intact. Other
#		metadata is hashed with Fletcher-16.
# 
# 		Lastly, a counter is added at the end. If two different modules
# 		get the exact same name (extremely unlikely) we use a counter to
#		distinguish them.

my @modules = (
	{name => "Foo::Bar", meta => {auth=>'mailto:dave@example.com', ver=>'1.2.0'}},
	{name => "Foo::動", meta => {auth=>'mailto:chang@example.com', ver=>'2.1.3'}}
);

say filename(@modules[0]<name>,@modules[0]<meta>);
say filename(@modules[1]<name>,@modules[1]<meta>);

sub filename($module,%meta) {
	my $filename = strencode($module);
	for %meta.sort {
		my $v = .value ~~ m/[\D & <-[.]>]/ ?? fletcher16(.value) !! .value;
		$filename ~= "-" ~ .key ~ ":$v";
	}
	return $filename ~ "--0";
}
sub strencode($str) {
	return $str.subst(/(<-alpha -[_:]>)/,{ charencode($0) },:g);
}
sub charencode($char) {
	my ($url,$hex) = ('',int2hex(ord $char));

	$hex = '0' ~ $hex if ($hex.chars % 1);
	while $hex.chars {
			$url ~= '%' ~ $hex.substr(0,2);
			$hex = $hex.substr(2);
	}
	return $url;
}
sub int2hex($val is rw) {
	my $hex = '';
	while $val {
		my $tmp = $val % 16;
		$val = int($val/16);
		$hex = ($tmp < 10 ?? $tmp !! chr (97 - 10 + $tmp)) ~ $hex;
	}
	return $hex;
}
sub fletcher16($str) {
	my ($A,$B) = (0,0);
	for map { .ord }, $str.comb -> $val {
		if $val > 255 {
			$A = ($A + int($val/255)) % 255;
			$B = ($B + $A) % 255;
		}
		$A = ($A + $val % 255) % 255;
		$B = ($B + $A) % 255;
	}
	return sprintf "%04s", int2hex($A*256 + $B);
}

