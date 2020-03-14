use v6;

=begin pod

=TITLE Random Guess

=AUTHOR Nelo Onyiah

For this event you’ll be creating a game. Okay, maybe not the most
interesting game you’ve even seen (hey, this is the Beginner’s Division
after all), but a game nonetheless. In this game, your script will generate
a random number between 1 and 50, and the user will be required to guess
that number.

For Windows PowerShell and Perl this will be a standard command-line script.
The script will display a message asking the user to enter a number between
1 and 50. The script will compare the number supplied by the user to a
randomly-generated number. If the numbers don’t match, the script will
display a message indicating whether the guess was too high or too low and
ask them to guess again.

When the user guesses correctly, the script will display the random number
and the number of guesses it took to reach the correct number. At that point
the game is over, so the script will end.

L<http://web.archive.org/web/20081210124629/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent8.mspx>

=end pod

our $number  = (1..50).pick(1);
our $guesses = 0;

sub is_valid($guess) {
    unless $guess ~~ /^ \d+ $/ && 1 <= $guess <= 50 {
        warn "Invalid input ($guess).";
        return;
    }
    return $guess;
}

sub MAIN() {
    loop {
        my $guess = prompt "Enter a number between 1 and 50: ";

        next unless is_valid $guess;

        $guesses++;

        if $guess == $number {
            say "Got it in $guesses guess(es)!";
            last;
        }
        elsif $guess  > $number { say 'Too high' }
        elsif $guess  < $number { say 'Too low'  }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
