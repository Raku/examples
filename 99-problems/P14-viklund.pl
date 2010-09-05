use v6;
# Specification:
#   P14 (*) Duplicate the elements of a list.
# Example:
# > say ~dupli(<a b c c d>);
# a a b b c c c c d d


say (map { $_ xx 2 }, <a b c c d>).perl;

# vim:ft=perl6
