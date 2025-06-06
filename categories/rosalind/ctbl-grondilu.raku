use v6;

=begin pod

=TITLE Creating a Character Table

=AUTHOR L. Grondin

L<http://rosalind.info/problems/ctbl/>

Sample input

    (dog,((elephant,mouse),robot),cat);

Sample output

    00110
    00111

=end pod

sub MAIN(Str $input = "(dog,((elephant,mouse),robot),cat);") {
    my $line = $input;
    $line .= chop;
    my $names = rx / <.ident>+ | <?after <[(,]> > <?before <[),]> > /;
    my @name = $line.comb: $names;
    my @sorting = map *.value, sort *.key, (@name Z=> ^@name);
    $line ~~ s:g/$names/0/;
    $line ~~ s:g/','//;

    while $line ~~ / \( 0 ** 2..* \) / {
        my $array = join(
            '',
            .prematch,
            .subst(/0/, '1', :g),
            .postmatch,
        ).subst(/<[()]>/, '', :g) given $/;
        unless $array ~~ /^[ 0+ | 1+ ]$/ {
            say $array.comb[@sorting].join: '';
        }
        $line ~~ s/\( (0+) \)/$0/;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
