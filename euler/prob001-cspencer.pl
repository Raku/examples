(1..^1000).grep({ ! ($^a % 3 and $^a % 5) }).reduce({ $^a + $^b }).say;

# vim: expandtab shiftwidth=4 ft=perl6
