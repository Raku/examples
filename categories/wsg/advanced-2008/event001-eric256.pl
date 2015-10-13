use v6;

=begin pod

=TITLE Could I Get Your Phone Number?

=AUTHOR Eric Hodges

In Could I Get Your Phone Number? competitors are given a phone number and
then—using the letters found on a standard phone dial—construct a word in
which the letters correspond to the numbers in the phone number.

Event Scenario

As you probably know, phone numbers can be difficult to remember; that’s why
many companies and organizations use mnemonic devices – such as acronyms and
jingles – to make their phone numbers a little more memorable.

What’s that? Can we give you an example of one of those mnemonic devices?
You bet we can. For example, suppose the Scripting Guys had the phone number
727-4787. That’s hard to remember; therefore, the Scripting Guys might tell
people to dial SCRIPTS instead. The word SCRIPTS – in which the letters in
the word correspond to the numbers in the phone number – is a mnemonic
device: it makes it easier for you to remember something.

Good question: how do you get SCRIPTS out of a phone number like 727-4787?
Well, on a standard phone dial, the digits 2 through 9 have all been
assigned letter values in addition to their numeric value:

=begin table
Digit   Letter Values
=====   =============
2       A B C
3       D E F
4       G H I
5       J K L
6       M N O
7       P R S
8       T U V
9       W X Y
=end table

It’s these corresponding letter values that enable us to derive the word
SCRIPTS from of the phone number 727-4787:

=begin table
7  S
2  C
7  R
4  I
7  P
8  T
7  S
=end table

That’s pretty cool; SCRIPTS is way easier to remember than 727-4787. On the
other hand, trying to figure out which word – if any – can be made from a
given phone number is kind of challenging. What would really be cool is
script that can convert a phone number to a word.

Now, try to guess what you need to do for Event 1 in the Advanced Division.

Good guess. Your task in Event 1 is this: given a seven-digit phone number
(e.g., 732-3464), create a seven-letter word corresponding to those digits.
Keep in mind that you can only use the three letter values that correspond
to each digit. For example, the word you create for 732-3464 must start with
the letter P, R, or S. Why? Because the phone number starts with the number
7, and, on the standard phone dial, those three letters are the only letters
associated with the number 7. In case you’re wondering, one possible
solution for 732-3464 is the word READING:

=begin table
7  3  2  3  4  6  4
=  =  =  =  =  =  =
R  E  A  D  I  N  G
=end table

To receive credit for this event you must come up with a seven-letter word;
any other use of the seven letters (for example, a four-letter word plus a
three-letter word) will not be accepted. In addition, the word must appear
in the file WordList.txt, an official word list that is included as part of
the Scripting Games’ Competitors Pack. On top of that, keep in mind that: 1)
although there might be multiple solutions for a given phone number your
script should only display one solution; and 2) the script should only
display a correct solution. Please don’t display all possible solutions; for
example, don’t do this:

    PDBEGMH
    READING
    SFCFHOI

If you do, we’ll have to disqualify your entry. Instead, display only a
single correct solution, like so:

    READING

Your script must prompt the user to enter a phone number (either via the
command line or using an Input box). When the scripts are tested, phone
numbers will be entered without the hyphen; thus the number 732-3464 will
actually be entered into the program like this:

    7323464

In other words, you do not need to include code that removes the hyphen from
the phone number; the hyphen will never appear in the phone number. Oh, and
when your script reads from the file WordList.txt (trust us: your script
will need to do that) make sure this file is in the folder C:\Scripts. If
the file is in any other folder, your script will likely fail when we test
it.

L<http://web.archive.org/web/20080321224441/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/aevent1.mspx>

=end pod

sub MAIN(Bool :$verbose = False) {
    my $input-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, "wordlist.txt");
    my %dict = (($input-file.IO.lines.grep: {.chars == 7}) X 1).flat;

    my %digits = (
        2 => (<a b c>),
        3 => (<d e f>),
        4 => (<g h i>),
        5 => (<j k l>),
        6 => (<m n o>),
        7 => (<p r s>),
        8 => (<t u v>),
        9 => (<w x y>),
    );

    my $phone_number = 7323464;
    my @test_words;

    for $phone_number.comb {
        say $_, "->", %digits{$_}.join('-') if $verbose;
        if (@test_words.elems) {
            my @values = %digits{$_}.values;
            @test_words = @test_words X~ '' X~ @values;
        }
        else {
            @test_words = %digits{$_}.values;
        }
    }

    say "Comparing {@test_words.elems} words against a dictionary of {%dict.elems} entries"
        if $verbose;
    for @test_words -> $word {
        $word.uc.say if defined %dict{$word};
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
