use v6;

=begin pod

=TITLE P12 - Decode a run-length encoded list.

=AUTHOR David Romano

=head1 Specification

   P12 (**) Decode a run-length encoded list.
       Given a run-length code list generated as specified in problem P11.
       Construct its uncompressed version.

=head1 Example

    > say prob12(([<4 a>],'b',[<2 c>],[<2 a>], 'd', [<4 e>]));
    a a a a b c c a a d e e e e

=end pod

my @l = ([('4', 'a')],'b',[('2', 'c')],[('2','a')], 'd', [('4','e')]);
sub prob12 (@in) {
    my @out;
    for 0 ... (@in.end) -> $x {
        if @in[$x] ~~ Array {
            loop (my $i=0; $i < @in[$x][0]; $i++) {
                push @out, @in[$x][1];
            };
        }
        else {
            push @out, @in[$x];
        }
    }
    return @out;
}

say @l.perl;
say prob12(@l).perl;

# vim: expandtab shiftwidth=4 ft=perl6
