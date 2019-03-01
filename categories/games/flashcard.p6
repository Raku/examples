#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Flashcard

=AUTHOR David Romano

Learn foreign language vocabulary using flashcards.

=end pod

my %table = (:context => (), :text => (), :link => (), :item => (), :group => ());
# item => ({ text => @text[0], context => %table{'context'}[0], score => 0 # },...)
# group = ({ 'link' => 1, itemA =>  item[0], itemB => item[1] } );

sub add-to-array ( $name, *@values, :$debug = 1) {
    %table{$name}.push(@values);
    if $debug {
        say "$name is now <{%table{$name}.[]}>";
    }
}

my $name = 'context';
add-to-array(<context>, <English French Latin> );
add-to-array(<text>, <hello bonjour salve> );
add-to-array(<link>, <idiom translation> );

sub list-context {
    for %table<context>.[] {
        .say;
    }
}

list-context;
# add-item: text_id-text_id context_id-context_id
sub add-item () {

}

# add-group item_id-item_id link_id
sub add-group () {

}

# question: can there be multiple links between the same two items? multiple
# contexts for an item? The reason I'm pondering this is that for the example
# above, it might make sense to have the link be a list (idiom, translation)
# rather than just simply 'idiom'. The ordering of the list should count, so
# that it's a 'translation' _of_ 'idiom', but I dunno. Are links and contexts
# really just the same? No, that's a good separation. Well, for now I can keep
# them as scalars and make them lists if I want to later.

# vim: expandtab shiftwidth=4 ft=perl6
