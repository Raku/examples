use v6;

=begin pod

=TITLE You Call That a Strong Password?

=AUTHOR Eric Hodges

In You Call That a Strong Password? competitors must write a script that,
based on the supplied criteria, determines the strength of a password.

Event Scenario

In this day and age, people are encouraged to use “strong” passwords any
time they need to create or change a password. That’s good advice, but it
also leads to a couple of questions: 1) what exactly is a strong password,
and 2) along the same lines, how can we tell whether a given password is
strong or not? Event 5 is designed to help you answer those two questions.

In this event you will create a script that can determine the “strength” of
a password. Password strength will be determined by submitting the password
to the following checks. The script must do all of the following:

=item B<Make sure that the password is not an actual word.> The password
      rhubarb fails this test because rhubarb is an actual word. To determine
      whether a word is an actual word or not, always use the file WordList.txt,
      an official word list that is included as part of the Scripting Games
      Competitors’ Pack. (Make sure you put this file in the folder C:\Scripts.)
      Note that this check should be case-insensitive: not only is rhubarb an
      actual word but so is RHUBARB, rhUBArb, etc.

=item B<Make sure that the password, minus the last letter, is not an actual
      word.> For example, the password rhubarb5 fails this test because, if you
      remove the last letter, the remaining string value – rhubarb – is an actual
      word. This check should be case-insensitive.

=item B<Make sure that the password, minus the first letter, is not an actual
      word.> For example, the password @rhubarb fails this test because, if you
      remove the first letter, the remaining string value – rhubarb – is an actual
      word. This check should be case-insensitive.

=item B<Make sure that the password does not simply substitute 0 (zero) for the
      letter o (either an uppercase O or a lowercase o).> For example, the password
      t00lb0x fails this test. Why? Because if you replace each of the zeroes with
      the letter O you’ll be left with an actual word: toolbox.

=item B<Make sure that the password does not simply substitute 1 (one) for the
      letter l (either an uppercase L or a lowercase l).> For example, the password
      f1oti11a fails this test. Why? Because if you replace each of the ones with
      the letter L you’ll be left with an actual word: flotilla.

=item B<Make sure that the password is at least 10 characters long but no more
      than 20 characters long.> The password rhubarb fails this test because it has
      only 7 characters.

=item B<Make sure that the password includes at least one number (the digits 0
      through 9).> The password rhubarb%$qwC fails this test because it does not
      include a number.

=item B<Make sure that the password includes at least one uppercase letter.> The
      password rhubarb fails this test because it does not have an uppercase
      letter.

=item B<Make sure that the password includes at least one lowercase letter.> The
      password RHUBARB fails this test because it does not have a lowercase
      letter.

=item B<Make sure that the password includes at least one symbol.> This can be
      any character that is neither an uppercase or lowercase letter, or a number;
      that would include – but not be limited to – the symbols ~, @, #, $, % and
      ^.

=item B<Make sure that the password does not include four (or more) lowercase
      letters in succession.> The password rhubARB fails this test because it
      includes four lowercase letters (rhub) in succession.

=item B<Make sure that the password does not include four (or more) uppercase
      letters in succession.> The password rHUBArb fails this test because it
      includes four uppercase letters (HUBA) in succession.

=item B<Make sure that the password does not include any duplicate characters.>
      The password rhubarb fails this test because it has two r’s and two b’s.
      This check should be case-sensitive: A and a are to be considered separated
      letters. Thus the password Oboe would not fail this particular test.

Note. Yes, that is a lot to remember, isn’t it? To help you keep track of
everything we’ve included a checklist (Password_Checklist.doc) in the
Competitors’ Pack.

To successfully complete this event, your script must accept a possible
password as a command-line argument and rate that password. For example, if
you want to rate the strength of the password rhubarb33! you would start
your script using a command similar to this command:

    myscript.pl rhubarb33!

Your script should start out with a password score of 13; that means that a
password that passed every single check will have a final score of 13. After
retrieving the password from the arguments collection (and we will pass the
script only one password at a time) your script should run each of the
previously-mentioned checks against that password. If the password passes a
given check (for example, the test that checks to see if the password is an
actual word) then the script should simply go on to the next test. That
should be easy enough.

Now, what happens if the password fails a given check? For example, the
password rhubarb will fail the test that says a password cannot have four
consecutive lowercase letters. In that case, the script must do two things:

=item Subtract 1 from the password score. For example, if the password score
      is 11 and the script fails the check for four consecutive lowercase letters
      then the password score should be lowered to 10

=item Echo back a message stating that the proposed password has failed this
      test. For example, in this case you would echo back a message similar to
      this:

    Four consecutive lowercase letters in password.

After all the checks have been made the script should then rate the
password, using the following scale:

=item A score of 6 or less represents a weak password.
=item A score of 7, 8, 9, or 10 represents a moderately-strong password.
=item A score of 11 or more represents a strong password.

You should echo back both the score and the password rating. For example:

    A password score of 4 indicates a weak password.

As an example, here’s the kind of output you should get when you check the
password rhubarb33!:

=begin code
No uppercase letters in password.
Four consecutive lowercase letters in password.
Duplicate letters in password.

A password score of 10 indicates a moderately-strong password.
=end code

That’s all you need to do.

L<http://web.archive.org/web/20080410170315/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/aevent5.mspx>

=end pod

sub MAIN(Str :$pw = "", Bool :$verbose = False) {
    my $password = $pw || prompt("Enter password to test: ");

    my $input-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "wordlist.txt");
    my %dict = (($input-file.IO.lines.grep: {.chars > 6}) X 1).flat;

    say "Testing strength of password '$password'" if $verbose;

    my $score = 13;

    if %dict{$password} :exists {
        $score--;
        say "Password matched dictionary";
    }

    if %dict{$password.substr(0, $password.chars -1 )} :exists {
        $score--;
        say "Password minus last char is in dictionary";
    }

    if %dict{$password.substr(1,$password.chars-1)} :exists {
        $score--;
        say "Password minus first char is in dictionary";
    }

    my $test = $password;
    $test.subst(/0/, "o");
    if %dict{$test} :exists {
        $score--;
        say "Password replaces 'o' with '0'";
    }

    $test = $password;
    $test.subst(/1/, "i");
    if %dict{$test} :exists {
        $score--;
        say "Password replaces 'i' with '1'";
    }

    if $password.chars == none(10..20) {
        $score--;
        say "Password is too short (less than 10) or too long (more than 20)"
    }

    unless $password ~~ rx/<[A..Z]>/ {
        $score--;
        say "No uppercase letters in password.";
    }

    if $password ~~ rx/<[a..z]> ** 4..*/ {
        $score--;
        say "Four consecutive lowercase letters in password.";
    }

    my @chars = $password.split('');
    my %letter-frequency;
    for @chars -> $char {
        if $char ~~ rx/<[a..zA..Z]>/ {
            %letter-frequency{$char} =
                %letter-frequency{$char}:exists ?? ++%letter-frequency{$char} !! 1;
        }
    }
    if %letter-frequency.values.any > 1 {
        $score--;
        say "Duplicate letters in password.";
    }

    say "'$password' scored $score" if $verbose;

    say "";
    given $score {
        when $_ <= 6 {
            say "A password score of $score indicates a weak password.";
        }
        when 7 < $_ <= 10 {
            say "A password score of $score indicates a moderately-strong password.";
        }
        when $_ >= 11 {
            say "A password score of $score indicates a strong password.";
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
