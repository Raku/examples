use v6;

my $line = get; #"(dog,((elephant,mouse),robot),cat);";
$line .=chop;
my $names = rx / <.ident>+ | <?after <[(,]> > <?before <[),]> > /;
my @name = $line.comb: $names;
my @sorting = map *.value, sort *.key, (@name Z=> ^@name);
$line ~~ s:g/$names/0/;
$line ~~ s:g/','//;

while $line ~~ / \( 0 ** 2..* \) / {
    my $array = join(
	'',
	.prematch,
	.subst(/0/, '1', :g),
	.postmatch,
    ).subst(/<[()]>/, '', :g) given $/;
    unless $array ~~ /^[ 0+ | 1+ ]$/ {
	say $array.comb[@sorting].join: '';
    }
    $line ~~ s/\( (0+) \)/$0/;
}

# vim: ft=perl6
