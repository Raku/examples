use v6;

=begin pod

=TITLE Valid Number

=AUTHOR Steve Mynott

You want to check if a string is a valid number.

# XXX pugs currently ignores types for everything but MMD.

  # Most of the time you will not need to do this.  Rather then testing
  # for a scalar's numerical nature you can ensure that the variable
  # contains a number by setting its type.  Assigning a number to
  # that variable will cause it to be coerced into an integer or a
  # number.

  # Ensure that a variable is used to store a real number.

  my Num $number;

  # Ensure that a variable is used to store an integer.

  my Int $integer;

  # Sometimes you need to validate a string from some source
  # corresponds to a real or an integer.  In this situation compare
  # it against the rule for integers or reals.

# XXX At the moment you have to make use of modules/Grammar/Perl6.pm
# to get below working.  When grammar support is more mature this
# will be fixed.

  given $string {
    say "Integer" if /^<Int>$/;
    say "Rational"  if /^<Rat>$/;
  }

=end pod

# vim: expandtab shiftwidth=4 ft=perl6
