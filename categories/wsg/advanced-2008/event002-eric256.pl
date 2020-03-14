use v6;

=begin pod

=TITLE Skating on Thin Ice

=AUTHOR Eric Hodges

In Skating on Thin Ice competitors must write a script that determines the
winner of a figure skating competition.

Event Scenario

If you’re likely the Scripting Guys, your fondest wish in life is to be able
to judge a figure skating contest. Event 2 in the Advanced Division is proof
that wishes really do come true.

OK, if you want to get picky, you don’t actually get to judge a figure
skating contest; the judging has already been done for you. Instead, all you
have to do is determine who actually won the contest, using a formula
roughly similar to that used by the International Skating Union. Sounds fun,
huh?

To determine the winner your script must use the scoring information found
in the text file Skaters.txt (which can be found in the Scripting Games
Competitors’ Pack). Each line in the text file consists of information for
an entrant in the competition; more specifically, each line contains the
skater’s name followed by the scores awarded by each of the seven judges:

    Ken Myer,55,66,76,67,59,70,54

To calculate Ken Myer’s score you (or, more precisely, your script) must do
the following:

=item Throw out the highest of his seven scores (76).
=item Throw out the lowest of his seven scores (54).
=item Average the remaining five scores (55, 66, 67, 59, and 70).

Thus Ken Myer would receive a score of 63.4 (55 + 66 + 67 + 59 +70, all
divided by 5).

To receive credit for this event your script must report back the winners of
the gold (skater with the highest score); silver (skater with the
second-highest score); and bronze (skater with the third-highest score)
medals, along with their score. Your final output should look similar to
this:

    Gold medal: Ken Myer, 63.4
    Silver medal: Pilar Ackerman, 62.78
    Bronze medal: Jonathan Haas, 61.8272

If another of your fondest wishes is to successfully complete this event,
make sure you place the file Skaters.txt in the folder C:\Scripts; if you
use any folder other than C:\Scripts then your script is likely to fail.
Also, you must display the results in the command window; do not overwrite
the file Skaters.txt. If you do overwrite the file, you will not receive any
points for the event. (And we won’t be very happy with you, because you’ll
have overwritten our copy of the file!)

Note that your script does not have to include code for handling ties. We’ve
set up the scores to make sure that there won’t be any ties for the top 3
positions.

L<http://web.archive.org/web/20080325083541/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/aevent2.mspx>

=end pod

my $input-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "skaters.txt");
my @lines = slurp($input-file).split("\n");

my %skaters ;
for @lines {
    next unless .chars > 0;
    my @data = .split(',');
    my $score = [+] (@data[1..7].sort)[2..6];
    %skaters{@data[0]} = $score / 5
}

my ($gold, $silver, $bronze) = %skaters.pairs.sort({$^b.value <=> $^a.value})[0,1,2];
say "Gold: {$gold.key}: {$gold.value}";
say "Silver: {$silver.key}: {$silver.value}";
say "Bronze: {$bronze.key}: {$bronze.value}";

# vim: expandtab shiftwidth=4 ft=perl6
