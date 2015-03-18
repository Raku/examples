module Perl6::Example;

use v6;

#| Encapsulates an example's metadata
class Example is export {
    has $.title is rw;
    has $.author is rw;
    has $.category is rw;
    has $.subcategory is rw;
    has $.filename is rw;
    has $.pod-link is rw;
    has $.pod-contents is rw;
}

#| Encapsulates a category's metadata
class Category is export {
    has $.key is rw;
    has $.title is rw;
    has @.subcategories is rw;
}

#| Manipulates groups of Category objects
class Categories is export {
    has %.categories-table;
    has @.categories-list;

    submethod BUILD(:%categories-table, :@categories-list) {
        %!categories-table = %categories-table;
        @!categories-list = gather for %!categories-table.keys -> $category-key {
            take Category.new(key => $category-key, title => %!categories-table{$category-key});
        }
    }

    method append-subcategories(:$to-category, :$subcategories) {
        for self.categories-list -> $category {
            given $category.key {
                when $to-category {
                    $category.subcategories = $subcategories.categories-list;
                    say $category;
                }
            }
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
