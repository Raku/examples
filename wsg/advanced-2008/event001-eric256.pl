
my @words = slurp("wordlist.txt").split('\n');
my %digits = (
	2 => <a b c>,
	3 => <d e f>,
	4 => <g h i>,
	5 => <j k l>,
	6 => <m n o>,
	7 => <p r s>,
	8 => <t u v>,
	9 => <w x y>,
);
my $phone_number = 7323464;	
for $phone_number.split('') {
	say $_, "->", %digits{$_};
}


