# A trivial parser that handles quoted strings with backslash-escaped
# quotes and either single or double quotes used to delimit.

grammar String::Simple::Grammar {
    rule TOP {^ <string> $}
    # Note for now, {} gets around a rakudo binding issue
    token string { <quote> {} <quotebody($<quote>)> $<quote> }
    token quote { '"' | "'" }
    token quotebody($quote) { ( <escaped($quote)> | <!before $quote> . )* }
    token escaped($quote) { '\\' ( $quote | '\\' ) }
}

# The parse-tree builder ultimately returns the string itself.
class String::Simple::Actions {
    method TOP($/) { make $<string>.made }
    method string($/) { make $<quotebody>.made }
    method quotebody($/) { make [~] $0.map: {.<escaped>.made or ~$_} }
    method escaped($/) { make ~$0 }
}

# Now define some tests that assure us that the grammar works...
use Test;

plan(6);

# Save these to variables just for brevity
my $grammar = ::String::Simple::Grammar;
my $actions = String::Simple::Actions.new();

# The semantics of our string are:
# * Backslash before a backslash is backslash
# * Backslash before a quote of the type enclosing the string is that quote
# * All chars including backslash are otherwise literal

ok $grammar.parse(q{"foo"}, :$actions), "Simple string parsing";
is $grammar.parse(q{"foo"}, :$actions).made, "foo", "Content of matched string";
is $grammar.parse(q{"f\oo"}, :$actions).made, "f\\oo", "Content of matched string";
is $grammar.parse(q{"f\"oo"}, :$actions).made, "f\"oo", "Content of matched string";
is $grammar.parse(q{"f\\\\oo"}, :$actions).made, "f\\oo", "Content of matched string";
nok $grammar.parse(q{'f\\\\oo"}, :$actions).made, "Mixed quotes should not work";

# vim: sw=4 softtabstop=4 ai expandtab filetype=perl6
