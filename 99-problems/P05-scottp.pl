use v6;

# Specification:
#   P05 - Reverse a list

# a. One line example
# 	<> used to create an array
# 	.reverse on the object to reverse the order
# 	.join called to present the data with a " "
# 	say displays the result
say <A B C D>.list.reverse.join(' ');

# b. Perl representation
#	.perl serialises the data as perl representation (like Data::Dumper in perl5)
#	.say to display the result (print with a new line)
<A B C D>.list.reverse.perl.say;

=begin pod
=head1 NAME

P05 - Reverse a list

=end pod

