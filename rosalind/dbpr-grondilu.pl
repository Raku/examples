use v6;
use LWP::Simple;
my $id = get;
for split "\n", LWP::Simple.get(qq{http://www.uniprot.org/uniprot/$id.txt}) {
    if / GO\; .* \sP\: (.*?)\;/ {
        say $/[0].Str
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
