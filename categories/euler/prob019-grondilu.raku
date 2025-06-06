use v6;

=begin pod

=TITLE Counting Sundays

=AUTHOR L. Grondin

L<https://projecteuler.net/problem=19>

You are given the following information, but you may prefer to do some
research for yourself.

=item 1 Jan 1900 was a Monday.
=item Thirty days has September,
      April, June and November.
      All the rest have thirty-one,
      Saving February alone,
      Which has twenty-eight, rain or shine.
      And on leap years, twenty-nine.
=item A leap year occurs on any year evenly divisible by 4, but not on a century unless it is divisible by 400.

How many Sundays fell on the first of the month during the twentieth century
(1 Jan 1901 to 31 Dec 2000)?

=end pod

# A good guess:

say 100 * 12 div 7

# vim: expandtab shiftwidth=4 ft=perl6
