use v6;

unless @*ARGS {
    say 'WARNING';
    say 'This is going to take *really* long (order of magnitude: 30 h) with';
    say 'the default number (1e7)';
    say 'To run it for a small number, simply supply that number';
    say  'on the command line.';
}

my %ser;
%ser{1}  = 1;
%ser{89} = 89;

my @squares = map { $_ * $_ }, 0..9;

sub ser($i is copy) {
    return %ser{$i} if %ser.exists($i);
    my @to_update;
    while !%ser.exists($i) {
        @to_update.push($i);
        $i = [+] $i.split('').map: { $_ * $_ };
    }
    my $s = %ser{$i};
    %ser{$_} = $s for @to_update;
    return $s;
}

my $c = 0;
my $target = @*ARGS[0] // 1e7;
say "running up to $target";
for 1..($target-1) {
    .say if $_ % ($target / 10).Int == 0;
    ++$c if ser($_) == 89;
}
say "Result: $c";

# vim: ft=perl6

