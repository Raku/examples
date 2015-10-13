use v6;

use Test;

plan 15;

{
    my $name = "100-doors.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    Door 1 is open
    Door 4 is open
    Door 9 is open
    Door 16 is open
    Door 25 is open
    Door 36 is open
    Door 49 is open
    Door 64 is open
    Door 81 is open
    Door 100 is open
    END
    is($output, $expected-output, $name);
}

{
    my $name = "24-game.pl";
    my $output = run-example($name, script-input => "1*2*3*4", script-args => "1 2 3 4");
    my $expected-output = q:to/END/;
    Here are your digits: 1 2 3 4

    24-Exp? 1*2*3*4 = 24
    You win!
    END
    is($output, $expected-output, $name);
}

{
    my $name = "accumulator-factory.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    10
    END
    is($output, $expected-output, $name);
}

{
    my $name = "ackermann-function.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    4
    END
    is($output, $expected-output, $name);
}

{
    my $name = "arbitrary-precision-integers.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    5**4**3**2 = 62060698786608744707...92256259918212890625 and has 183231 digits
    END
    is($output, $expected-output, $name);
}

{
    my $name = "balanced-brackets.pl";
    my $output = run-example($name, script-input => "4");
    like($output, rx/\[? || \]? well\-balanced/, $name);
}

{
    my $name = "binomial-coefficient.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    10
    END
    is($output, $expected-output, $name);
}

{
    my $name = "copy-a-string.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    Hello.
    Goodbye.
    Hello.
    Hello.
    Goodbye.
    Goodbye.
    END
    is($output, $expected-output, $name);
}

{
    my $name = "create-a-two-dimensional-array-at-runtime.pl";
    my $output = run-example($name, script-input => "3 5");
    like($output, rx/^^'Dimensions'/, $name ~ ": contains prompt");
    like($output, rx/['@' \s]+/, $name ~ ": contains array element symbols");
    $output.=chomp;
    my $match = $output ~~ m:g/['@' \s+]+/;
    my $num-rows = (split /\n/, $match).elems;
    is($num-rows, 3, $name ~ ": three rows of @ chars");
    my @num-ats-in-row = (split /\n/, $match).map: { (split /\s+/, $_).elems };
    my $num-cols = max @num-ats-in-row;
    is($num-cols, 5, $name ~ ": five columns of @chars");
}

{
    skip("hailstone sequence uses too much time and memory");
    if False {
        my $name = "hailstone-sequence.pl";
        my $output = run-example($name);
        my $expected-output = q:to/END/;
        END
        is($output, $expected-output, $name);
    }
}

{
    my $name = "last-fridays-of-year.pl";
    my $output = run-example($name, script-args => "2015");
    my $expected-output = q:to/END/;
    2015-01-30
    2015-02-27
    2015-03-27
    2015-04-24
    2015-05-29
    2015-06-26
    2015-07-31
    2015-08-28
    2015-09-25
    2015-10-30
    2015-11-27
    2015-12-25
    END
    is($output, $expected-output, $name);
}

{
    my $name = "prime-decomposition.pl";
    my $output = run-example($name);
    my $expected-output = q:to/END/;
    233 1103 2089
    END
    is($output, $expected-output, $name);
}

sub run-example($name, :$script-input = Nil, :$script-args = Nil) {
    my $base-dir = "categories/best-of-rosettacode";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";

    $base-cmd ~= qq{ "$script-args" } if  $script-args;

    my $output = $script-input ?? qqx{echo $script-input | $base-cmd }
                               !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
