use v6;

=begin pod

=head1 Balanced brackets

Generate a string with N opening brackets (“[”) and N closing brackets (“]”), in some arbitrary order.
Determine whether the generated string is balanced; that is, whether it consists entirely of pairs of opening/closing brackets (in that order), none of which mis-nest.

=head1 More

L<http://rosettacode.org/wiki/Balanced_brackets#Perl_6>

=head1 What's interesting here?

=item idiomatic solutions
=item hyper operators
=item switch statement
=item roll
=item grammar

=head2 Depth counter

=end pod

{
  sub balanced($s) {
    my $l = 0;
    for $s.comb {
        when "]" {
            --$l;
            return False if $l < 0;
        }
        when "[" {
            ++$l;
        }
    }
    return $l == 0;
  }
 
  my $n = prompt "Number of brackets >";
  my $s = (<[ ]> xx $n).pick(*).join;
  say "$s {balanced($s) ?? "is" !! "is not"} well-balanced";
}

=begin pod

=head2 FP oriented

=end pod

{
  sub balanced($s) {
    .none < 0 and .[*-1] == 0
      given [\+] '\\' «leg« $s.comb;
  }
 
  my $n = prompt "Number of bracket pairs: ";
  my $s = <[ ]>.roll($n*2).join;
  say "$s { balanced($s) ?? "is" !! "is not" } well-balanced";
}

=begin pod

=head2 String munging

=end pod

{
  sub balanced($_ is copy) {
    s:g/'[]'// while m/'[]'/;
    $_ eq '';
  }
 
  my $n = prompt "Number of bracket pairs: ";
  my $s = <[ ]>.roll($n*2).join;
  say "$s is", ' not' xx not balanced($s), " well-balanced";
}

=begin pod

=head2 Prasing with a grammar

=end pod

{

  grammar BalBrack {
    token TOP { ^ <balanced>* $ };
    token balanced { '[]' | '[' ~ ']' <balanced> }
  }

  my $n = prompt "Number of bracket pairs: ";
  my $s = <[ ]>.roll($n*2).join;
  say "$s { BalBrack.parse($s) ?? "is" !! "is not" } well-balanced";

}

=begin pod

=head1 Features used

=item C<roll> - L<http://perlcabal.org/syn/S32/Containers.html#roll>
=item C<given> - L<http://perlcabal.org/syn/S04.html#Switch_statements>
=item C<prompt> - L<http://perlcabal.org/syn/S32/IO.html#prompt>
=item C<grammar> - L<http://perlcabal.org/syn/S05.html#Grammars>

=end pod

# vim: expandtab shiftwidth=2 ft=perl6:
