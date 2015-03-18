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


sub get-categories(%categories) is export {
    my @categories = categories-list(%categories);
    @categories = append-subcategories(@categories);

    return @categories;
}

sub append-subcategories(@categories) {
    my %cookbook-categories-table;
    my %wsg-categories-table;
    for @categories -> $category {
        given $category.key {
            when "cookbook" {
                $category.subcategories =
                    categories-list(%cookbook-categories-table);
            }
            when "wsg" {
                $category.subcategories =
                    categories-list(%wsg-categories-table);
            }
        }
    }

    return @categories;
}

sub categories-list(%categories) {
    return gather for %categories.keys -> $subcategory {
        take Category.new(key => $subcategory, title => %categories{$subcategory});
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
