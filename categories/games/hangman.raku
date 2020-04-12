#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Hangman

=AUTHOR Sterling Hanenkamp

Play Hangman from a word list of your choice. It will attempt to use the
wordlist in the Unix dictionary file at F</usr/share/dict/words> if you do not
name a different list of words.

=head1 USAGE

    perl6 hangman.p6

=end pod

class HangingMan {
    enum DeathStage <NotHanging Head Body LeftLeg RightLeg LeftArm RightArm DeadDeadDead>;

    constant @STAGES =
        q:to/END_OF_NOT_HANGING/,
        /----|
        |
        |
        |
        |
        |
        ==========
        ||      ||
        END_OF_NOT_HANGING
        q:to/END_OF_HEAD/,
        /----|
        |   😶
        |
        |
        |
        |
        ==========
        ||      ||
        END_OF_HEAD
        q:to/END_OF_BODY/,
        /----|
        |   😐
        |    |
        |    |
        |
        |
        ==========
        ||      ||
        END_OF_BODY
        q:to/END_OF_LEFT_LEG/,
        /----|
        |   😑
        |    |
        |    |
        |     \
        |
        ==========
        ||      ||
        END_OF_LEFT_LEG
        q:to/END_OF_RIGHT_LEG/,
        /----|
        |   😟
        |    |
        |    |
        |   / \
        |
        ==========
        ||      ||
        END_OF_RIGHT_LEG
        q:to/END_OF_LEFT_ARM/,
        /----|
        |   😧
        |    |\
        |    |
        |   / \
        |
        ==========
        ||      ||
        END_OF_LEFT_ARM
        q:to/END_OF_RIGHT_ARM/,
        /----|
        |   😫
        |   /|\
        |    |
        |   / \
        |
        ==========
        ||      ||
        END_OF_RIGHT_ARM
        q:to/END_OF_DEAD_DEAD_DEAD/,
        /----|
        |   😵
        |   /|\
        |    |
        |   / \
        |
        ==========
        ||      ||
        END_OF_DEAD_DEAD_DEAD
        ;

    has $.death-stage = NotHanging;

    method worsen() { $!death-stage = DeathStage($!death-stage + 1) }
    method is-dead-dead-dead { $!death-stage eqv DeadDeadDead }

    method gist() { @STAGES[ $!death-stage ] }
    method Str() { @STAGES[ $!death-stage ] }
}

class X::GameException is Exception { }

class X::AlreadyGuessed is X::GameException {
    has $.letter;
    method message { "You already guessed $.letter." }
}

class X::BadLetter is X::GameException {
    has $.letter;
    method message { "You said $.letter, but that is not a letter." }
}

class GuessState {
    has Str $.original;
    has Str @!word;
    has Str @!correct;
    has Str @!remaining = 'A' .. 'Z';

    submethod BUILD(:$!original) {
        $!original .= uc;
        @!word    = $!original.comb;
        @!correct = $!original.comb.map(-> $l { $l ~~ /<[A..Z]>/ ?? "_" !! $l });
    }

    method letters-left { @!correct.grep("_").elems }
    method is-winner { $.letters-left == 0 }

    method render-remaining { @!remaining.join(" ") };
    method render-word { @!correct.join(" ") };

    method guess($letter is copy) {
        $letter .= uc;

        X::BadLetter.new(:$letter).throw
            unless $letter ~~ /<[A..Z]>/;

        X::AlreadyGuessed.new(:$letter).throw
            if $letter !~~ any(|@!remaining);

        @!remaining .= grep({ $_ !~~ $letter });

        my $success = False;
        for @!word.kv -> $i, $l {
            if $l eq $letter {
                @!correct[$i] = $l;
                $success = True;
            }
        }

        return $success;
    }

    method gist { "$.render-word\n\nLetters Left:\n$.render-remaining" }
    method Str { $.gist }
}

sub MAIN($word-file-name = "/usr/share/dict/words") {
    my $word-file = $word-file-name.IO;
    unless $word-file ~~ :f {
        note "usage: $*PROGRAM-NAME wordfile";
        note "Unable to read words from $word-file-name";
        exit 1;
    }

    my $word = $word-file.slurp.lines.pick;
    my $win-state = GuessState.new(original => $word);
    my $lose-state = HangingMan.new;

    loop {
        say $lose-state;

        if $lose-state.is-dead-dead-dead {
            say "Sorry, you lose.";
            say "The word was $win-state.original().";
            return;
        }

        say $win-state;
        my $letter = prompt "Pick a letter: ";

        $lose-state.worsen unless $win-state.guess($letter);

        if $win-state.is-winner {
            say q:to/END_OF_WIN/;
                /----|
                |
                |  \😅/
                |    |
                |    |
                |   / \
                ==========
                ||      ||

                You win! The word was $win-state.original().
                END_OF_WIN
            return;
        }

        CATCH {
            when X::GameException { .message.say }
        }
    }
}
