use v6;

=begin pod

=TITLE One of These Things is not Like the Others

=AUTHOR Eric Hodges

This event is a matching game. We'll provide you with some arrays, and you
have to write a script that reports which element in each array is different
from the others.

Event Scenario

If you have an apple, an orange, and a carrot, which one doesn't belong?
We'd have to say the carrot, because the apple and the orange are fruits,
whereas the carrot is a vegetable. In this event you'll take groups of three
elements and determine which element is different from the others. You'll
start with five arrays, with three elements in each array:

    $a1 = ("monday", "MONDAY", "monday");
    $a2 = ("TUESDAY", "tuesday", "tuesday");
    $a3 = ("WEDNESDAY", "wednesday", "wednesday");
    $a4 = ("thursday", "thursday", "THURSDAY");
    $a5 = ("friday", "FRIDAY", "friday");

To receive the 5 points for this event you must write a script that reports
which of the three elements in each array is different from the other two.
For example, the second element in array 1 is different, so your output
would look something like this:

a1: second

L<http://web.archive.org/web/20070228055412/http://www.microsoft.com/technet/scriptcenter/funzone/games/games07/bevent3.mspx>

=end pod

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

# vim: expandtab shiftwidth=4 ft=perl6
