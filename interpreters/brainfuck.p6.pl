# 
# Interpreter for the Brainfuck programming language.
# USAGE: perl6 brainfuck.p6.pl < myprog.bf
# 
# Contributed by Daniel Carrera, inspired by Acme::Brainfuck
# 

# Read the program.
my $program = $*IN.slurp;

# Compile to Perl 6.
$program .= subst(/ <-[+\-<>,.\[\]]> /, '', :g);
$program .= subst(/(\++)/, { 'P += ' ~ $0.chars ~ ";" }, :g);
$program .= subst(/(\-+)/, { 'P -= ' ~ $0.chars ~ ";" }, :g);
$program .= subst(/(\>+)/, { '$ptr += ' ~ $0.chars ~ ";" }, :g);
$program .= subst(/(\<+)/, { '$ptr -= ' ~ $0.chars ~ ";" }, :g);
$program .= subst(/\./, "print chr P;", :g);
$program .= subst(/\,/, "P = ord getc;", :g);
$program .= subst(/\[/, 'while (P) {', :g);
$program .= subst(/\]/, '};', :g);
$program .= subst(/P/, '@P[$ptr]', :g);
$program  = 'my @P = (); my $ptr = 0;' ~ $program;

# Run
eval $program;

=begin END
=head1 Brainfuck Interpreter

USAGE: perl6 brainfuck.p6.pl < myprog.bf

Below is "Hello world" in Brainfuck:

=begin code
++++++++++    initializes cell zero to 10
[
   >+++++++>++++++++++>+++>+<<<<-
]             loop sets the next four cells to 70/100/30/10 
>++.          print   'H'
>+.           print   'e'
+++++++.              'l'
.                     'l'
+++.                  'o'
>++.                  space
<<+++++++++++++++.    'W'
>.                    'o'
+++.                  'r'
------.               'l'
--------.             'd'
>+.                   '!'
>.                    newline
=end code
