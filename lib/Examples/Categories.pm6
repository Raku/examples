use v6;

unit module Examples::Categories;

#| Encapsulates a category's metadata
class Category is export {
    has $.key is rw;
    has $.title is rw;
    has $.subcategories is rw;
    has %.examples is rw;
}

#| Manipulates groups of Category objects
class Categories is export {
    has %.categories-table;
    has %.categories;

    submethod TWEAK {
        for %!categories-table.kv -> $key, $title {
            %!categories{$key} = Category.new(
                                            :$key,
                                            :$title,
                                            );
        }
    }

    method categories-list {
        return %!categories.pairs.sort.map(*.value);
    }

    method append-subcategories(:$to-category, :$subcategories) {
        for self.categories-list -> $category {
            given $category.key {
                when $to-category {
                    $category.subcategories = $subcategories;
                }
            }
        }
    }

    method keys {
        return %!categories-table.keys;
    }

    method category-with-key($key) {
        return %!categories{$key};
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
