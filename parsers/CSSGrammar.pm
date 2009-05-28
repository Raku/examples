# This should be doing css2.1; hopefully CSS3 when that's ready (but that may be a while)

grammar CSSGrammar {
        # builtin: ident (we use cssident), alpha

        token TOP       { ^ <css> $ | <.panic: "CSS parsing failed"> };
#       token css       { <ruleset> | <media> | <page> };
        token css       { <ruleset> };
#       rule ruleset    { <selector> ** ',' '{' <declaration> ** ';' '}' };
        rule ruleset    { <selector> [ ',' <selector> ]* '{' <declaration> [ ';' <declaration> ]* 
'}' | <.worry: "Failed to find any rules" > };
#       token selector  { <simple_selector> ** <combinator> ] };
        token selector  { <simple_selector> [ <combinator> <simple_selector> ]* };
        token simple_selector   { <element_name> [ <hcap> ]* | <hcap>+ };
        token hcap      { '#' | <class> | <attrib> | <pseudo> };
        token class     { '.' <cssident> };
        token element_name { <cssident> | '*' };
        token attrib    { '[' <cssident> [ [ '=' | <INCLUDES> | <DASHMATCH> ] [ <cssident> | <stri
ng> ] ]? ']' };
        token pseudo    { ':' [ <cssident> | <FUNCTION> <cssident>? ')' ] };
        token combinator   { '+' | '>' | '' };

        token declaration  { <property> ':' <expr> <prio>? | '' };
        token property  { <cssident> };
        token prio      { <important_sym> };
#       token expr      { <term> ** <operator> }
        token expr      { <term> [ <operator> <term> ]* };
        token cssident  { '-'?<namestart><namechar>* };
        rule term       { <unary_operator>? 

                [ <number> | <percentage> | <length> | <ems> | <exs> | <angle> | <time> | <freq> ]
                | <string> | <cssident> | <uri> | <hexcolor> | <function>
        };
        token operator  { '/' | ',' | '' };
        token function  { <FUNCTION> <expr> ')' };
        token hexcolor  { '#' };
        token namestart { <alpha> | _ };
        token namechar  { \w | '-' };
        token unary_operator { '-' | '+' };
        token number    { \d+ | \d* '.' \d+ };
        token percentage { <number> '%' };
        token length    { <number> [ px | cm | mm | in | pt | pc ] };
        token ems       { <number> em };
        token exs       { <number> ex };
        token angle     { <number> [ deg | rad | grad ] };
        token time      { <number> [ ms | s ] };
        token freq      { <number> k?hz };
        token string    { ('"' | \') (<[^\n\r\f\\"]>|\\<nl>)* $0 };
        token nl        { \n | \r\n | \r };
        token uri       { url '(' [ <string> | <url>] ')'};
        token url       { ( \w | <[:/]> )* };
        token FUNCTION  { <cssident> '(' };
        token important_sym { '!'important };


#       token media     {};
#       token page      {};

        method panic($e) {
            die $e;
        }
}
