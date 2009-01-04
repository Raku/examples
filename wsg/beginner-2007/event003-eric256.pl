use v6;

sub find_unique (@x) {
	my %test;
	%test{$_}++ for @x;
    return %test.pairs.first( { .value == 1 });
};

my @a1 = ("monday", "MONDAY", "monday");
my @a2 = ("TUESDAY", "tuesday", "tuesday");
my @a3 = ("WEDNESDAY", "wednesday", "wednesday");
my @a4 = ("thursday", "thursday", "THURSDAY");
my @a5 = ("friday", "FRIDAY", "friday");


find_unique(@a1).key.say;
find_unique(@a2).key.say;
find_unique(@a3).key.say;
find_unique(@a4).key.say;
find_unique(@a5).key.say;
