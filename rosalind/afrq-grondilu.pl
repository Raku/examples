use v6;

sub MAIN($data-string = "0.1 0.25 0.5") {
    my @A = $data-string.split(' ')».Num;

    say @A».&afrq.fmt('%.3g');
}

sub afrq($r) { 1 - (1 - sqrt $r)**2 }

# 0.532 0.75 0.914

# vim: expandtab shiftwidth=4 ft=perl6
