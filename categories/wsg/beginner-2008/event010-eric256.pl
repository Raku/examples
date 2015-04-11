use v6;

=begin pod

=TITLE Bowling

=AUTHOR Eric Hodges

In Bowling, competitors will be given the score card for a 10-frame bowling
game and asked to calculate the score.

The game of bowling involves rolling a ball down an alley and trying to
knock over 10 pins arranged in a triangular formation. The bowler gets two
chances to do this. If all 10 pins are knocked down in the first roll,
that’s called a “strike.” A strike is represented on the scorecard by an X.
If the bowler knocks down some of the pins on the first roll and the
remainder of the pins on the second roll, that’s called a “spare.” A spare
is indicated on the scorecard by a /.

If a bowler fails to knock down all the pins with two rolls, he or she
receives a score indicating the number of pins knocked down. For example, if
he knocks down 4 pins on the first roll and 3 on the second, his score is 7.

A spare is calculated by taking the 10 points for knocking down all the
pins, plus the points from the next roll. For example, if he knocks down 8
pins then 2, that’s a spare. In the next frame (a “frame” being the next
attempt at knocking down 10 pins) the bowler’s first roll knocks down 4
pins. That means that, for the frame in which he got the spare, the bowler
receives 14 points. On a bowling scorecard that looks like this:

What this means is that in order to calculate the total for the spare frame,
you have to wait until the first ball in the next frame is thrown. A strike
is similar, except that you get to count the next two rolls, rather than the
next one. So if the bowler gets a strike in frame 1, he receives ten points
for the strike, but he also receives the points for the next two rolls. If
the next two rolls knock down 6 and then 3, the total score for frame 1 is
19 (10 + 6 + 3), and the score for frame 2 is 9 (6 + 3). That gives a
running total after the first two frames of 28, like this:

Your challenge for this event is to calculate the score based on this set of
10 frames:

Before you get started, we’re going to give you a little bit of a hint. Not
just a hint, but we’re going to give you a starting point for your script.
There are probably other ways to do this, but you’re going to be using an
array. Why? Because we’re going to give you the array:

    @arrFrames = (2,5,7,"/",8,1,"X",9,"/",5,3,7,0,4,5,"X",2,0)

Why did we give you the array? Because when we test the entries for this
event, we’re going to replace this array with a different one. That means
your script needs to work with any 10-frame bowling score, not just the one
we showed you here.

Note: In case you’re wondering what happens if a strike or spare occurs in
the last frame, in a real bowling game you’ll get a third roll of the ball
at the very end. In this event we’re not going to account for that. The last
frame in this event contains two numbers, no spares or strikes. Any array we
put in to test the scripts will also end with two numbers, no spares or
strikes in the very last frame. In other words, you don’t need to account
for spares or strikes in the last frame.  Top of page

L<http://web.archive.org/web/20081208155503/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent10.mspx>

=head1 Solution

L<http://web.archive.org/web/20081210124632/http://www.microsoft.com/technet/scriptcenter/funzone/games/solutions08/bpssol10.mspx>

=end pod

my @frames = <2 5 7 / 8 1 X 9 / 5 3 7 0 4 5 X 2 0>;
my @pins;

my $score = 0;

sub score ($ball) {
    return 10  if  $ball eq 'X';
    return $ball;
};

while (@frames) {
    my $frame = @frames.shift;
    last unless defined $frame;
    say "checking $frame";
    given $frame {
        when '/' {
            $score += 10 + score(@frames[1]);
        }
        when 'X' {
            if @frames[1,2] ~~ *, '/' {
                $score += 20;
            }
            else {
                $score += 10 + score(@frames[1]) + score(@frames[2]);
            }
        }
        when '0'..'9' {
            if @frames.elems > 1 {
                $score += $frame unless defined @frames[1] eq '/';
            }
            else {
                $score += $frame;
            }
        }
    }

}
say "$score";

# vim: expandtab shiftwidth=4 ft=perl6
