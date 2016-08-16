use v6;

=begin pod

=TITLE CSS2.1 Grammar

=AUTHOR wayland76, David Warring

This should be doing CSS2.1; hopefully CSS3 when that's ready (but that may
be a while).

=end pod

grammar CSSGrammar {
        # builtin: ident (we use cssident), alpha

        token TOP         { ^ <import>* <css>* $ || <.panic: "CSS parsing failed"> }
        token css         { <ruleset> | <media> | <page> }
        rule ruleset      { <selector> +% ',' '{' ~ '}' <declarations> }
        rule declarations { <declaration> +%% ';' }
        rule selector     { <simple_selector> +% <combinator>? }
        rule simple_selector   { <element_name> [ <hcap> ]* | <hcap>+ }
        token hcap        { '#' | <class> | '[' ~ ']' <attrib> | <pseudo> }
        token class       { '.' <cssident> }
        token element_name { <cssident> | '*' }
        token attrib      { <cssident> [ [ '=' | <INCLUDES> | <DASHMATCH> ] [ <cssident> | <string> ] ]? }
        token pseudo      { ':' [ <FUNCTION> ~ ')' <cssident>? | <cssident> ] }
        token combinator  { '+' | '>' }

        rule declaration  { <property> ':' <expr> <prio>? }
        token property    { <cssident> }
        token prio        { <important_sym> }
        token expr        { <term> +% <operator>? }
        token cssident    { '-'?<namestart><namechar>* }
        rule term         { <unary_operator>?
                [ <percentage> | <length> | <ems> | <exs> | <angle> | <time> | <freq> | <number> ]
                | <string> | <uri> | <function> | <cssident> | <hexcolor>
        }
        token operator    { '/' | ',' }
        token function    { <FUNCTION> ~ ')' <expr> }
        token hexcolor    { '#' }
        token namestart   { <alpha> | _ }
        token namechar    { \w | '-' }
        token unary_operator { '-' | '+' }
        token number      { \d+ | \d* '.' \d+ }
        token percentage  {   <number> '%' }
        token length      {:i <number> [ px | cm | mm | in | pt | pc ] }
        token ems         {:i <number>? em }
        token exs         {:i <number>? ex }
        token angle       {:i <number> [ deg | rad | grad ] }
        token time        {:i <number> [ ms | s ] }
        token freq        {:i <number> k?hz }
        token string      { ('"' | \') (<- nl>|\\ \n)*? $0 }
        token uri         {:i url '(' ~ ')' [ <string> | <url>] }
        token url         { ( <- [\( \) \' \" \\]> )* }
        token FUNCTION    { <cssident> '(' }
        token INCLUDES    { '~=' }
        token DASHMATCH   { '|=' }

        token important_sym {:i '!'important }

        rule import       {:i'@import' [<string>|<uri>] <media_list>? ';' }

        rule media        {:i'@media' <media_list> <media_rules> }
        rule media_list   {<media_type> +%','}
        rule media_type   { <cssident> }
        rule media_rules  { '{' ~ '}' <ruleset>* }

        rule page         {:i'@page' [':'<cssident>]? '{' ~ '}' <declarations> }

        # Comments and whitespace.
        token comment {'<!--' .*? '-->' | '/*' .*? '*/'}
        token nl {\xA|"\r"\xA|"\r"|"\f"}
        token ws { <!ww> [ nl | "\t" | " " | <comment> ]* }

        method panic($e)  {die $e;}
}

# vim: expandtab shiftwidth=4 ft=perl6
