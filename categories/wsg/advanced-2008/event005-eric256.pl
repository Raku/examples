use v6;

my $input-file = $*PROGRAM_NAME.IO.dirname ~ "/wordlist.txt";
my %dict = ( ($input-file.IO.slurp.split("\n").grep: {.chars > 6}) X 1);

loop {
    my $password = prompt("Enter password to test: ");

    say "Testing strength of password '$password'";

    my $score = 13;

    if %dict.exists($password) {
        $score--;
        say "Password matched dictionary";
    }

    if %dict.exists($password.substr(0, $password.chars -1 ) ) {
        $score--;
        say "Password minus last char is in dictionary";
    }

    if %dict.exists($password.substr(1,$password.chars-1)) {
        $score--;
        say "Password minus first char is in dictionary";
    }

    my $test = $password;
    $test.replace("0","o");
    if %dict.exists($test) {
        $score--;
        say "Password replaces 'o' with '0'";
    }

    $test = $password;
    $test.replace("1","i");
    if %dict.exists($test) {
        $score--;
        say "Password replaces 'i' with '1'";
    }

    if $password.chars == none(10..20) {
        $score--;
        say "Password is too short (less than 10) or too long (more than 20)"
    }



    say "'$password' scored $score";
    say;
    say;
}

# vim: expandtab shiftwidth=4 ft=perl6
