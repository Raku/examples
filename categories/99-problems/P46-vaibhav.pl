use v6;

=begin pod

= TITLE P46 - Truth tables for logical expressions

= AUTHOR Vaibhav Mehra

=head1 Example:

    > my $result = and($A, or($A, not($B)));
    true true true
    true fail true
    fail true fail
    fail fail fail

=end pod

# we'll define subroutines
# for all the basic logic gates.

multi and ($input1, $input2) {
  if $input1 eq 'true' && $input2 eq 'true' {
    return 'true';
  }
  else {
    return 'fail';
  }
}

multi or ($input1, $input2) {
  if $input1 eq 'fail' && $input2 eq 'fail' {
    return 'fail';
  }
  else {
    return 'true';
  }
}

sub not ($input) {
  if $input eq 'true' {
    return 'fail';
  }
  else {
    return 'true';
  }
}

multi nor ($input1, $input2) {
  return not(or($input1, $input2));
}

multi nand ($input1, $input2) {
  return not(and($input1, $input2));
}

multi xor ($input1, $input2) {
  return or(and($input1, not($input2)), and(not($input1), $input2));
}

multi xnor ($input1, $input2) {
  return and(or($input1, not($input2)), or(not($input1), $input2));
}

# Using an example to understand the working
my $A = 'true';
my $B = 'true';
my $result = and($A, or($A, not($B)));
print "$A ";
print "$B ";
say $result;

$B = 'fail';
print "$A ";
print "$B ";
say $result;

$A = 'true';
$B = 'fail';
print "$A ";
print "$B ";
say $result;

$A = 'fail';
print "$A ";
print "$B ";
say $result;
