#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Perl 6 Cookbook: Introduction to Strings

=AUTHOR Scott Penrose

=head1 Definition

In Perl 6, a string is a sequence of zero or more characters and other
simple objects, forming a single unit of data of the type Str. A string
is data usually in its reportable or printable form. You can write a
Perl string using single-quotes '', double-quotes "", and various quote-like
operators. You can create and manipulate strings programmatically, in
many ways. In fact, this is what Perl does best.


=head1 Description

Perl 6 interprets strings depending on context.  A string may consist
of zero or more characters, including letters, spaces, numbers, and
other characters.

=head1 Declaring and assigning Strings

A string can be created explicitly, by declaring a variable using the
Str keyword, and assigning a string value to it.

    my Str $string = 'This Str is holding a String';

Or a string can be declared implicitly by assigning a string value to
a variable, in this case a scalar.  It automatically becomes a string
variable.

    my $scalar = 'Party time';

=end pod

my Str $string = 'This Str is holding a String';
my $scalar = 'Party time'; # Also a string

=begin pod

=head1 Displaying Strings

We display strings using print or say:

    print ""        ; # output is an empty string
    print "Hello\n" ; # output is Hello followed by a new line
    say   "Hello"   ; # same
    say   'Hello'   ; # same

=end pod

print ""        ; # output is an empty string
print "Hello\n" ; # output string is Hello followed by a new line
say   "Hello"   ; # same
say   'Hello'   ; # same

=begin pod

Both print and say also accept a list of things to display, and will
attempt to join all the things into a string:

    say "Hello", " World", "!"; # Hello World!

=end pod

say "Hello", " World", "!"; # Hello World!

=begin pod

Strings can be appended to one another, using the concatenation
operator, ~

Beware when using print and say; concatenation is slower than joining.

Here, three strings are concatenated into a single string.  Output is
Hello World! followed by a newline.

    my Str $str;
    $str = "Hello" ~ " World" ~ "!";
    say $str; # Hello World!
    $str.say; # As above

=end pod

{
  my Str $string;
  $string = "Hello" ~ " World" ~ "!";
  say $string; # Hello World!
  $string.say; # As above
}

=begin pod

=head1 Introspection

Perl 6 has extensive support for introspection, that is, to see the
internals of types and objects during runtime.  It is therefore
possible to find out if a variable is a string and act upon that
information.

We know we get a String when we declare something explicitly as Str:

    my Str $string = 'This is $string: a scalar holding a String';
    say $string;
    say '$string is ', $string.^name;                 # Str

We can also easily show that a general variable containing a String,
is in fact just that:

    my $scalar = 'This is $scalar holding a String';
    say $scalar;
    say '$scalar is ', $scalar.^name;                 # Str

=end pod

{
  my Str $string = 'This is $string: a scalar holding a String';
  say $string;
  say '$string is ', $string.^name;                 # Str

  my $scalar = 'This is $scalar holding a String';
  say $scalar;
  say '$scalar is ', $scalar.^name;                 # Str
}

=begin pod

=head1 Numbers as strings

A number may be interpreted as a string, depending on the context:

    say 1; # 1 is interpreted as a number
    say 2, " is a number interpreted as a string"; # 2 is a number interpreted as a string.
    say 1+2*3, " is a number interpreted as a string"; # 7 is a number interpreted as a string.

Note that Perl 6 ensures that the arithmetic expression before the
first comma is evaluated even without enclosing parentheses, and that
it is only afterwards that it is interpreted as a string.

=end pod

say 1; # 1 is a number
say 2, " is a number interpreted as a string"; # 2 is a number interpreted as a string.
say 1+2*3, " is a number interpreted as a string"; # 7 is a number interpreted as a string.

=begin pod

=head1 Strings as numbers

Conversely, sometimes a string might be interpreted as a number:

    print  +""     ; # a num-ified empty string evaluates as 0
    print  "1" + 1 ; # 2

The string, "1" is treated as a number in this context, added to the
number 1 by the + operator, which returns the number, 2, as a
string for output.

=end pod

say   +""     ; # a num-ified empty string evaluates as 0
say  "1" + 1  ; # 2

=begin pod

Context sensitivity is the essence of Perl.  Keeping this in mind, what
would you expect to be the output string, for the following?

    my $string = "1" ~ "1" + 10; # 12, 21, or even... "111"?
    say $string;

But, "1+1", surrounded by quotation marks, either '' or "", stringifies
the expression, so that it is evaluated as a string.

    say "1 + 1"; # literally: 1 + 1

To force the interpretation of a string for any programmatic
value it might contain, use the built-in EVAL() call:

    say EVAL "1 + 1";    # 2

On the command-line, you may pass a string to the perl 6 interpretor,
to have it evaluated as a program expression, by using the -e switch:

    ./perl6 -e "say 1+1"; # 2
    ./perl6 -e 'say "1+1"'; # 1+1

=end pod

{
  my $string = "1" ~ "1" + 10; # 12, 21, or even... "111"?
  say $string;
  say "1 + 1"; # literally: 1 + 1
  say EVAL "1 + 1";    # 2
}

=begin pod

Assignments of non-strings set the variable to the appropriate type:

    my $scalar = 1234;
    say $scalar; # 1234
    say '$scalar is ', $string.^name   # $scalar is Int

An object can be stringified, by using the ~ operator immediately
prior to the variable's sigil

    say '~$scalar is ', (~$scalar).^name; # ~$scalar is Str

=end pod

$scalar = 1234;
say $scalar; # 1234
say '$scalar is ', $scalar.^name;
say '~$scalar is ', (~$scalar).^name;

=begin pod

=head1 Quotes, Interpolation and Quote-like operators

=head2 Single-quoted Strings

Strings that are written with single quotes are almost
verbatim.  However, backslashes are an escape character.
This is so that you can write literal single-quotes
within a single-quoted string, and also be able to write
a backslash at the end of a single-quote-enclosed string:

    say 'n\'     ; # Error: perl sees no closing '
    say '\\'     ; # \
    say 'n\''    ; # n'
    say 'n\n'    ; # n\n
    say 'n\\n'   ; # n\n
    say 'n\\\n'  ; # n\\n better spelled as:
    say 'n\\\\n' ; # n\\n


A few other backslashy escapes work in single quotes too

=head2 Double-quoted Strings

If you want to interpolate variables and other special characters
within a literal string, use double quotes around the value:

    my $var1 = 'dog' ;
    say "The quick brown fox jumps over the lazy $var1";


=head2 Interpolation

Double-quoted strings interpolate the elements of an array or
a hash, closures, functions, backslashed control characters, and
other good stuff.  Single-quoted strings do not.

    # literal whitespace
    my $squot = '    The quick brown fox jumps over the lazy dog.
    	dog.';
    my $dquot = "    The quick brown fox jumps over the lazy
    	dog.";
    say $squot;
    say $dquot;

    # Double-quotes interpolate special backslash values,
    # but single-quotes do not
    say 'The quick brown fox\n\tjumps over the lazy dog\n';
    say "The quick brown fox\n\tjumps over the lazy dog\n";

    # interpolate array elements:
    my @animal = ("fox", "dog");
    say 'The quick brown @animal[0] jumps over the lazy @animal[1]';
    say "The quick brown @animal[0] jumps over the lazy @animal[1]";

    # interpolate hash elements:
    my %animal = (quick => 'fox', lazy => 'dog');
    say 'The quick brown %animal{\'quick\'} jumps over the lazy %animal{\'lazy\'}.';
    say "The quick brown %animal{'quick'} jumps over the lazy %animal{'lazy'}.";

    # interpolate methods, closures, and functions:
    say '@animal.elems() {@animal.elems} &elems(@animal)';
    say "@animal.elems() {@animal.elems} &elems(@animal)";

=end pod

# literal whitespace
my $squot = '    The quick brown fox jumps over the lazy dog.
	dog.';
my $dquot = "    The quick brown fox jumps over the lazy
	dog.";
say $squot;
say $dquot;

# Double-quotes interpolate special backslash values,
# but single-quotes do not
say 'The quick brown fox\n\tjumps over the lazy dog\n';
say "The quick brown fox\n\tjumps over the lazy dog\n";

# Variables
my $var1 = 'dog' ;
say 'The quick brown fox jumps over the lazy $var1';
say "The quick brown fox jumps over the lazy $var1";

# interpolate array elements:
my @animal = ("fox", "dog");
say 'The quick brown @animal[0] jumps over the lazy @animal[1]';
say "The quick brown @animal[0] jumps over the lazy @animal[1]";

# interpolate hash elements:
my %animal = (quick => 'fox', lazy => 'dog');
say 'The quick brown %animal{\'quick\'} jumps over the lazy %animal{\'lazy\'}.';
say "The quick brown %animal{'quick'} jumps over the lazy %animal{'lazy'}.";

# interpolate methods, closures, and functions:
say '@animal.elems() {@animal.elems} &elems(@animal)';
say "@animal.elems() {@animal.elems} &elems(@animal)";

=begin pod

=head2 Perl's Quote-like Operators

It's often useful to use something other than single or double quotes
when declaring strings. To do so use the q// and qq// quote operators,
which provide advanced interpolation control:

    # Single quoted strings
    say 'I have to escape my \'single quotes\' in this string';
    say q/This string allows 'single quotes' seamlessly/;

    # Double quoted strings
    say "I have to escape my \"double quotes\" in this string";
    say qq/This string allows "double quotes" seamlessly/;

The slashes in q// and qq// can be replaced with most of the
delimiters that worked in Perl 5. All of Unicode above Latin-1 is reserved
for user-defined quotes.

    # Single quoted strings
    say q'Many delimiters are available for quoting';
    say q"Many delimiters are available for quoting";
    say q`Many delimiters are available for quoting`;
    say q[Many delimiters are available for quoting];
    say q<Many delimiters are available for quoting>;
    say q{Many delimiters are available for quoting};
    say q?Many delimiters are available for quoting?;

    # But not the colon B<:>
    q:illegal_perl6:; #legal perl 5

    # Also a space is needed below, because q() is a function call
    say q (Many delimiters are available for quoting);

=head2 Advanced Interpolation Control

Perl 6 allows very fine control over string quoting using the q//
quote operator with specialized adverbs. For instance, q:s// signifies
that we only want scalars interpolated. These adverbs can also be
expressed in a short form, for instance q:s// can be expressed as
qs//.

    :s          :scalar         Interpolate $ vars
    :a          :array          Interpolate @ vars
    :h          :hash           Interpolate % vars
    :f          :function       Interpolate & calls
    :c          :closure        Interpolate {...} expressions
    :b          :backslash      Interpolate \n, \t, etc. (implies :m)
    :w          :words          Split result on words (no quote protection)
    :ww         :quotewords     Split result on words (with quote protection)
    :x          :exec           Execute as command and return results
    :t          :to             Interpret result as heredoc terminator

    # Raw quoting: no escaping at all (unless otherwise adverbed)
    say Q/(no interpolation) even backslash has no special meaning: \\ \/;

    # Single quoting:
    say 'Lots of options for single quotes';
    say q/Lots of options for single quotes/;

    # Double quoting: interpolates scalars, arrays, hashes, functions,
    # closures, and backslash codes
    say "Plenty of ways to double quote too";
    say qq/Plenty of ways to double quote too/;

    # Interpolate scalars only:
    say q:s/The quick brown $var1 jumps over the lazy dog/;
    say qs/The quick brown $var1 jumps over the lazy dog/;

    # Interpolate @ vars only:
    say q:a/The quick brown @animal[0] jumps over the lazy @animal[1]/;
    say qa/The quick brown @animal[0] jumps over the lazy @animal[1]/;
    say qa/We have @animal.elems() elements in @animal[]/;

    # interpolate % vars only:
    say q:h/The quick brown %animal{'quick'} jumps over the.../;
    say qh/The quick brown %animal{'quick'} jumps over the.../;
    say qh/We have %animal.elems() key in %animal{}/;

    # interpolate functions only: both & and () are required
    sub get_animal ($tag) { return %animal{$tag}; }
    say q:f/The quick brown &get_animal('quick') jumps.../;
    say qf/The quick brown &get_animal('quick') jumps.../;

    # interpolate closures only:
    say q:c/The quick brown { 'fox'; } jumps.../;
    say qc/The quick brown { 'fox'; } jumps.../;

    # interpolate backslash codes only:
    say q:b/The quick brown fox\n\tJumps over the lazy dog/;
    say qb/The quick brown fox\n\tJumps over the lazy dog/;

Adverbs can be strung together to make a specialized quoting
environment for your string.

    # interpolate only scalars and array variables:
    say q:s:a/The quick brown $fox jumps over the lazy @animal[1]/;

=head2 Special adverbs and synonyms

=over 4

=item :w Split on words

    my ($fox,$dog)     = q:w/brown lazy/;
    my @array          = qw/fox dog/;

The <> synonym for q:w has many uses

    @animals           = <fox dog monkey>;
    say @animals[0]    ; # fox
    %animal            = <brown fox lazy dog>;
    say %animal<lazy>  ; # dog

=item :ww Split on Quoted Words

    @animals           = q:ww<"brown fox" "lazy dog">;
    # Quoted words and variable interpolation
    @animals           = qq:ww/"brown $fox" "lazy %animal{'lazy'}"/;

The «» synonym for qq:ww has many uses, also spelled <<>>

    ($fox,$dog)          = «brown lazy»;
    ($fox,$dog)          = <<brown lazy>>; # same
    %animal              = « $fox fox lazy "lazy dog" »;
    say %animal« $dog »  ; # lazy dog
    say %animal<<$dog>>    ; # lazy dog

=item :x Execute

TODO

=back

=item :t Defining Multiline Strings (Here Documents)

Multiline strings (here documents) can be defined using the q// and qq//
operators with the :to adverb added.

    # A double quoted multiline string:
    my $a = qq:to/EOF/;
        This is a multiline here document terminated by EOF on a
        line by itself with any amount of whitespace before or
        after the termination string. Leading whitespace equivalent
        to the indentation of the delimiter will be removed from
        all preceding lines.
        EOF

When defined in this way the whitespace at the start of each line will
be removed up to the same amount of indentation used by the closing
delimiter, a tab character being equal to 8 normal spaces.

A here document can be as exacting with adverbs as any other quoted
string. For instance you can specify that you only want scalars
interpolated by adding the :s adverb.

    # This multiline string will only interpolate scalars
    my $multiline = q:s:to/EOF/;
        This $scalar will be interpolated, but this @array won't be.
        EOF

These adverbs apply to the body of the heredoc, not to the terminator,
because the terminator has to be known at compile time. This means
that q:s:to/EO$thing/ doesn't do what you mean.

=end pod

# vim: expandtab shiftwidth=4 ft=perl6
