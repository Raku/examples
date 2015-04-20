use v6;

=begin pod

=TITLE Quartets

=AUTHOR L. Grondin

L<http://rosalind.info/problems/qrt/>

Sample input

    cat dog elephant ostrich mouse rabbit robot
    01xxx00
    x11xx00
    111x00x

Sample output

    {elephant, dog} {rabbit, robot}
    {cat, dog} {mouse, rabbit}
    {mouse, rabbit} {cat, elephant}
    {dog, elephant} {mouse, rabbit}

=end pod

proto combine (Int, @) {*}
multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    gather {
        take [$head, @$_] for combine($n-1, @tail);
        take [ @$_ ] for combine($n, @tail);
    }
}
 
sub ncombine($n, $k) {
    (state@)[$n][$k] //= combine($k, [^$n])
}

my $default-input = q:to/END/;
    cat dog elephant ostrich mouse rabbit robot
    01xxx00
    x11xx00
    111x00x
    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-input;
    my @data = $input.lines;

    my %seen;
    my @taxa = @data.shift.words;
    for @data -> $line {
        my %h = @taxa Z=> $line.comb;
        my @classif =
        classify( { %h{$_} }, @taxa )<0 1>;
        next if any(@classif) < 2;
        note "processing $line";
        my @a = map { [ @classif[0][@$_] ] }, ncombine(@classif[0].elems, 2)[];
        my @b = map { [ @classif[1][@$_] ] }, ncombine(@classif[1].elems, 2)[];
        for @a X @b -> $a, $b {
            my $left = $a.sort.join(', ');
            my $right = $b.sort.join(', ');
            next if %seen{$left}{$right}++ ?| %seen{$right}{$left}++;
            say '{' ~ $left ~ '} {' ~ $right ~ '}';
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
