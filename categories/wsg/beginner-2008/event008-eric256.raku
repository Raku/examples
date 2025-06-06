use v6;

=begin pod

=TITLE Random Guess

=AUTHOR Eric Hodges

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

my $num = (1..50).pick[0];
my $guesses = 0;
my $guess = 0;


loop {
    $guess = prompt("Pick a number between 1 and 50: ");
    $guesses++;
    given $guess {
        when $num {
            say "You guessed correctly in {$guesses} guesses!";
            last;
        };
        when $_ < $num {say "You guessed too low."};
        when $_ > $num {say "You guessed too high."};
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
