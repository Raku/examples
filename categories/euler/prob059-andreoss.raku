use v6;

=begin pod

=TITLE XOR decryption

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=59>

Each character on a computer is assigned a unique code and the preferred
standard is ASCII (American Standard Code for Information Interchange). For
example, uppercase A = 65, asterisk (*) = 42, and lowercase k = 107.

A modern encryption method is to take a text file, convert the bytes to
ASCII, then XOR each byte with a given value, taken from a secret key. The
advantage with the XOR function is that using the same encryption key on the
cipher text, restores the plain text; for example, 65 XOR 42 = 107, then 107
XOR 42 = 65.

For unbreakable encryption, the key is the same length as the plain text
message, and the key is made up of random bytes. The user would keep the
encrypted message and the encryption key in different locations, and without
both "halves", it is impossible to decrypt the message.

Unfortunately, this method is impractical for most users, so the modified
method is to use a password as a key. If the password is shorter than the
message, which is likely, the key is repeated cyclically throughout the
message. The balance for this method is using a sufficiently long password
key for security, but short enough to be memorable.

Your task has been made easy, as the encryption key consists of three lower
case characters. Using cipher.txt
C<https://projecteuler.net/project/resources/p059_cipher.txt>, a file
containing the encrypted ASCII codes, and the knowledge that the plain text
must contain common English words, decrypt the message and find the sum of
the ASCII values in the original text.

=end pod


my constant @common-words = <the was who not did with have does and one that>;

sub infix:<XOR>(@cipher, @password) {
    @cipher Z+^ flat (@password xx *);
}

sub as-code(Str $w) {
    my @x = $w.comb.map(*.ord)
}

sub as-word(*@s) {
    @s.map(*.chr).join
}

sub guess-password(Str $w, @cipher) {
    my @word = as-code $w;

    my @chunks = @cipher.rotor((@word.elems) => -(@word.elems - 1));
    my %tries;
    my $offset = 0;

    for @chunks -> @chunk {
        
        my @password  = @chunk[^3] XOR @word;
        
        my $password  = as-word @password;
        
        next unless $password ~~ /^^ <[a..z]> ** 3 $$/ ;
        my $decrypted = as-word @cipher[$offset .. *] XOR @password;
        
        my $count =  [+] do for @common-words.grep({$_ !~~ $w}) -> $word {
            elems $decrypted ~~ m:g:i/$word/
        }

        %tries{$password} += $count if $count > 0;

        return %tries if $count > @common-words.elems;

        $offset   += 1;
        $offset div= $w.chars;
    }
    %tries;
}

sub MAIN(Bool :$verbose = False,
        :$file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'cipher.txt'),
        :$word = @common-words[0],
        :$pass is copy,
        Bool :$test = False) {
    return TEST if $test;
    die "'$file' is missing" unless $file.IO.e ;
    my @cipher     = map *.Int, split /<[,]>/ , slurp $file;

    unless $pass {
        my %variants = guess-password $word, @cipher;
        $pass  = %variants.pairs.max(*.value).key;
        say "The password is more likely to be '$pass'. " if $verbose;
    }

    my $decrypted =  as-word @cipher XOR as-code($pass);
    
    say "The message: {$decrypted.perl}" if $verbose;
    say [+] as-code $decrypted;
    say "Done in {now - BEGIN now}" if $verbose;
}

sub TEST {
    use Test;
    is as-code("abc"), [97,98,99], "as-code works";
    is as-word(100,101,102), "def", "as-word works";
    is as-word([79,59,12] XOR [103,111,100]), "(Th", "XOR works";
    done;
}

# vim: expandtab shiftwidth=4 ft=perl6
