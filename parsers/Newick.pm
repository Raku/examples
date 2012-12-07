#| Newick tree format. L<https://en.wikipedia.org/wiki/Newick_format>
grammar Newick {
    rule TOP { <node> ';' }
    token node {
        <name>
        | '(' ~ ')' <node>+ % ',' <name>?
    }
    token name { <.ident>+ }
}

# vim: ft=perl6

