use v6;

=begin pod

=TITLE Simple strings

=AUTHOR Aaron Sherman

A trivial parser that handles quoted strings with backslash-escaped
quotes and either single or double quotes used to delimit.

=end pod

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

# vim: sw=4 softtabstop=4 ai expandtab filetype=perl6
