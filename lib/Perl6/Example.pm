module Perl6::Example;

use v6;

#| Encapsulates an example's metadata
class Example is export {
    has $.title;
    has $.author;
    has $.category;
    has $.subcategory;
    has $.filename;
    has $.pod-link;
}

# vim: expandtab shiftwidth=4 ft=perl6
