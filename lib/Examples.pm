use v6;

unit module Examples;

#| Encapsulates an example's metadata
class Example is export {
    has $.title is rw;
    has $.author is rw;
    has $.filename is rw;
    has $.pod-link is rw;
    has $.pod-contents is rw;
}

# vim: expandtab shiftwidth=4 ft=perl6
