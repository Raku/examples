use v6;

my @bottles = ((99...2) X~ ' bottles'),
              '1 bottle',
              'no more bottles',
              '99 bottles';

my @actions = 'Take one down and pass it around' xx 99,
              'Go to the store and buy some more';

for @bottles Z @actions Z @bottles[1..*] {
    say "$^a of beer on the wall, $^a of beer.
$^b, $^c of beer on the wall.\n".ucfirst;
}
