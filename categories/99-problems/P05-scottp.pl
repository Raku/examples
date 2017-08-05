use v6;

=begin pod

=TITLE P05 - Reverse a list

=AUTHOR Scott Penrose

Specification:

    P05 - Reverse a list

=end pod

# a. One line example
#       <> used to create an array
#       .reverse on the object to reverse the order
#       .join called to present the data with a " "
#       say displays the result
say <A B C D>.list.reverse.join(' ');

# b. Perl representation
#       .perl serialises the data as perl representation (like Data::Dumper in perl5)
#       .say to display the result (print with a new line)
<A B C D>.reverse.list.perl.say;

# vim: expandtab shiftwidth=4 ft=perl6
