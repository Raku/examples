use v6;

=begin pod

=TITLE 99 bottles of beer

=AUTHOR Gerhard R

Print the lyrics to the
L<99 bottles of beer|http://en.wikipedia.org/wiki/99_Bottles_of_Beer>
song.

=end pod

my @bottles = (flat ((99...2) X~ ' bottles'),
              '1 bottle',
              'no more bottles',
              '99 bottles');

my @actions = (flat 'Take one down and pass it around' xx 99,
              'Go to the store and buy some more');

for flat @bottles Z @actions Z @bottles[1..*] {
    say "$^a of beer on the wall, $^a of beer.
$^b, $^c of beer on the wall.\n".tc;
}

# vim: expandtab shiftwidth=4 ft=perl6
