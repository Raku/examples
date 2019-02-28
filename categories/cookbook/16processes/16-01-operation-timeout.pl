use v6;

=begin pod

=TITLE Timeout Operation

=AUTHOR stmuk

You want to timeout an operation (possibly long running)

=end pod

constant timeout = 3;

my $done = start {
    say "starting to sleep...";
    sleep 10; # long running operation here
}

await Promise.anyof($done, Promise.in(timeout));

if $done {
    say "operation completed";
}
else {
    warn "timed out after {timeout} sec(s)";
}

# vim: expandtab shiftwidth=4 ft=perl6
