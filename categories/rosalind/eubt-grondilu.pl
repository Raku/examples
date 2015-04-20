use v6;

=begin pod

=TITLE Enumerating Unrooted Binary Trees

=AUTHOR L. Grondin

L<http://rosalind.info/problems/eubt/>

Sample input

    dog cat mouse elephant

Sample output

    (((mouse,cat),elephant))dog;
    (((elephant,mouse),cat))dog;
    (((elephant,cat),mouse))dog;

=end pod

proto combine (Int, @) {*}
multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    map(
        { [$head, @^others] },
        combine($n-1, @tail)
    ),
    combine($n, @tail);
}
 
sub ncombine($n, $k) { (state %){$n}{$k} //= combine($k, [^$n]) }
sub eubt(@species) {
    if @species == 1 { return [ @species ] }
    elsif @species == 2 { return [ sprintf "(%s,%s)", @species ] }
    elsif @species >= 3 {
        gather for 1 .. +@species div 2 -> $k {
            my %seen;
            for ncombine(+@species, $k)[].map( { [ @species[@$_] ] } ) -> @picked {
                %seen{join ':', @picked}++;
                my @left = grep none(@picked), @species;
                next if %seen{join ':', @left};
                for (eubt(@picked) »~» ',') X~ eubt(@left) {
                    take [ "($_)" ]
                }
            }
        }
    }
    else { !!! 'unexpected number of species' }
}

sub MAIN($input = "dog cat mouse elephant") {
    my @data = $input.words;
    my $first = @data.shift;
    printf "(%s)%s\n", $_, $first for eubt @data;
}

# vim: expandtab shiftwidth=4 ft=perl6
