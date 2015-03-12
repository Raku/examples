use v6;

module Benchmark;

my sub time_it (Int $count where { $_ > 0 }, Code $code) {
    my $start-time = time;
    for 1..$count { $code.(); }
    my $end-time = time;
    my $difference = $end-time - $start-time;
    my $average = $difference / $count;
    return ($start-time, $end-time, $difference, $average);
}

multi sub timethis (Int $count, Str $code) is export {
    my $routine = eval "sub \{ {$code} \}";
    return time_it($count, $routine);
}

multi sub timethis (Int $count, Code $code) is export { 
    return time_it($count, $code);
}

sub timethese (Int $count, %h) is export {
    my %results;
    for %h.kv -> $k, $sub { 
        %results{$k} = timethis($count, $sub);
    }
    return %results;
}

# vim: expandtab shiftwidth=4 ft=perl6
