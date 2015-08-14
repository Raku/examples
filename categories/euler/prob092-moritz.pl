use v6;

=begin pod

=TITLE Square digit chains

=AUTHOR Moritz Lenz

L<https://projecteuler.net/problem=92>

A number chain is created by continuously adding the square of the digits in
a number to form a new number until it has been seen before.

For example,

=begin code :allow<B>
44 → 32 → 13 → 10 → B<1> → B<1>
85 → B<89> → 145 → 42 → 20 → 4 → 16 → 37 → 58 → B<89>
=end code

Therefore any chain that arrives at 1 or 89 will become stuck in an endless
loop. What is most amazing is that EVERY starting number will eventually
arrive at 1 or 89.

How many starting numbers below ten million will arrive at 89?

=end pod

unless @*ARGS {
    say 'WARNING';
    say 'This is going to take *really* long (order of magnitude: 30 h) with';
    say 'the default number (1e7)';
    say 'To run it for a small number, simply supply that number';
    say 'on the command line.';
}

my %ser;
%ser{1}  = 1;
%ser{89} = 89;

my @squares = map { $_ * $_ }, 0..9;

sub ser($i is copy) {
    return %ser{$i} if %ser{$i}:exists;
    my @to_update;
    while !(%ser{$i}:exists) {
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

# vim: expandtab shiftwidth=4 ft=perl6
