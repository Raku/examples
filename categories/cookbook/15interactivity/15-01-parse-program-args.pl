use v6;

=begin pod

=TITLE Parsing program arguments

=AUTHOR stmuk

Parse program arguments as passed from the command line

=end pod

# output is required parameter
sub MAIN (Str :$output!, Bool :$debug = False )  {
    say @*ARGS.perl; # direct way
    say :$output.perl, :$debug.perl; # better way
}

# %  perl6 15-01-parse-program-args.pl             
# Usage:
#   15-01-parse-program-args.pl --output=<Str> [--debug] 

# %  perl6 15-01-parse-program-args.pl --output=foo
# Array.new("--output=foo")
# "output" => "foo""debug" => Bool::False

# vim: expandtab shiftwidth=4 ft=perl6
