use v6;

=begin pod

=TITLE Poker hands

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=54>

The file, poker.txt, contains one-thousand random hands dealt to two
players. Each line of the file contains ten cards (separated by a single
space): the first five are Player 1's cards and the last five are Player 2's
cards. You can assume that all hands are valid (no invalid characters or
repeated cards), each player's hand is in no specific order, and in each
hand there is a clear winner.

How many hands does Player 1 win?

=end pod

enum Rank <
    Two Three Four Five
    Six Seven Eight Nine
    Ten Jack Queen King Ace
>;

enum Suit <
    Hearts Diamonds Clubs Spades
>;

enum Hand <
        RoyalFlush StraightFlush FourOfKind
        FullHouse Flush Straight ThreeOfKind
        TwoPairs OnePair HighCard
>;

multi counts(Positional $h) {
    bag($h).invert
}

multi strigify(Hash $x) {
    join ' and ', do for $x.kv -> $k, $v {
        "$k of $v"
    }
}

class Card {
    has Rank  $.rank;
    has Suit  $.suit;

    method parse-rank(Str $r) returns Rank {
        given $r {
            when /\d/ { Rank($r.Int - 2) }
            when /T/  { Ten }
            when /J/  { Jack }
            when /Q/  { Queen }
            when /K/  { King }
            when /A/  { Ace }
        }
    }
    method parse-suit(Str $s) returns Suit {
        given $s {
            when /H/ { Hearts }
            when /D/ { Diamonds }
            when /C/ { Clubs }
            when /S/ { Spades }
        }
    }
    multi method CALL-ME(Str $c where $c.chars == 2)  {
        my ($r, $s) = $c.comb;
        self.new(rank => Card.parse-rank($r),
                 suit => Card.parse-suit($s));
    }
    multi method CALL-ME(Rank $v, Suit $s) {
        self.new(rank => $v, suit => $s)
    }
}

multi infix:«<=>»(Card $a, Card $b) is export returns Order {
    $a.rank <=> $b.rank
}


class Deal {
    subset Ranks where -> $r {
        $r ~~ Rank || $r ~~ Array[Rank]
    };

    has Card   @.cards;
    has Ranks  %.score{Hand};

    method CALL-ME(Str $h) {
        my $x = self.new(
            cards => map { Card($_) } , $h.split: /\s/
        );
        $x.score = $x!best-hand;
        $x;
    }
    method ACCEPTS(Hand $h) {
        so %.score{$h};
    }
    method !best-hand {
        self!royal-flush
        // self!straight-flush
        // self!full-house
        // self!flush
        // self!straight
        // self!four-of-kind
        // self!three-of-kind
        // self!two-pairs
        // self!one-pair
        // self!high-card
    }

    method !straight {
        my @v = @.cards».rank.sort;
        if @v eq (@v.min ... @v.max).map({Rank($_)}) {
            (Straight) => @v.max
        }
    }

    method !flush {
        if [~~] @.cards».suit {
            (Flush) => Array[Rank].new: |@.cards».rank;
        }
    }

    method !royal-flush {
        if self!flush && self!straight && @.cards».rank.max ~~ Ace {
            (RoyalFlush) => Ace
        }
    }

    method !straight-flush {
        if self!flush && my $s = self!straight  {
            (StraightFlush) => $s.value
        }
    };
    method !four-of-kind {
        # Four cards of the same value.
        my @ranks = @.cards».rank;
        my @four  = @ranks.&counts.grep(*.key == 4);
        if so @four {
            (FourOfKind) => my $x = @four[0].value,
            (HighCard)   => max grep { $_ !~~ $x }, @ranks
        }
    }
    method !full-house {
        # Three of a kind and a pair.
        my Ranks %x{Hand} = flat self!three-of-kind , self!one-pair;
        if %x{ThreeOfKind}.defined && %x{OnePair}.defined {
            (FullHouse) => Ace
        }
    }

    method !three-of-kind {
        my $rank = @.cards».rank.&counts.grep(*.key == 3)[0];

        if $rank {
            my Ranks %h{Hand} = (ThreeOfKind) =>  my $x = $rank.value;

            if my $one-pair = @.cards».rank.&counts.grep(*.key == 2)[0] {
                %h{OnePair}  =  $one-pair.value;
            }
            else {
                %h{HighCard} = max grep { $_ !~~ $x }, @.cards».rank;
            }
            %h;
        }
    }

    method !two-pairs {
        my @pairs = @.cards»\
        .rank.&counts\
        .sort(*.key).grep(*.key == 2);
        if +@pairs == 2 {
            (OnePair)   => my $x= @pairs».value.min,
            (TwoPairs)  => my $y= @pairs».value.max,
            (HighCard)  => max grep { $_ !~~ $x | $y },@.cards».rank;
        }
    }

    method !one-pair {
        my $pair = @.cards»\
        .rank.&counts\
        .sort(*.key).grep(*.key == 2)[0];
        if $pair {
            (OnePair)  => my $x = $pair.value,
            (HighCard) => max grep { $_ !~~ $x}, @.cards».rank;
        }
    }

    method !high-card {
        (HighCard) => @.cards».rank.max;
    }
}

multi infix:«<=>»(Deal $a, Deal $b) returns Order {
    for Hand.enums.sort(*.value).keys.map({Hand($_)}) -> $h {
        return More if $a.score{$h}.defined && !$b.score{$h}.defined;
        return Less if $b.score{$h}.defined && !$a.score{$h}.defined;
        next unless $a.score{$h}.defined & $b.score{$h}.defined;

        if $a.score{$h} & $b.score{$h} ~~ List {
            my $cmp = max $a.score{$h} Z<=> $b.score{$h};
            return Less if $cmp ~~ Less;
            return More if $cmp ~~ More;
        }

        my $cmp =  $a.score{$h} <=> $b.score{$h};

        next if $cmp ~~ Same;
        return $cmp;
    }
    Same;
}

sub MAIN(Bool :$verbose    = False,
         Bool :$run-tests  = False,
         :$file   = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'poker.txt'),
         :$lines  = Inf, # read only X lines from file
        ) {
    die "'$file' is missing" unless $file.IO.e ;
    return TEST if $run-tests;

    say [+] gather for $file.IO.lines[^$lines] -> $line is copy {
        $line ~~ s:nth(5)/\s/;/;
        my ($h1,$h2) = $line.split: /';'/;
        my $d1 = Deal($h1);
        my $d2 = Deal($h2);
        if $d1 <=> $d2 ~~ More {
            say "player1 wins on $line \n\twith {$d1.score.&strigify} against {$d2.score.&strigify} " if $verbose ;
            take 1;
        }
    }

}

sub TEST {
    use Test;
    ok Card("TC") <=> Card("TD") ~~ Same, "cards are equal if ranks are equal ";
    ok Card("2C") <=> Card("AC") ~~ Less, "2C < AC";
    ok (Straight ~~ Deal("5H 6C 7S 8D 9D") )   &&
    (Straight !~~ Deal("2H 6C 7S 8D 9D"))  , "Detects straight";
    ok (Flush ~~ Deal("5H 7H 8H AH TH")) &&
    (Flush !~~ Deal("5H 7H 8H AC TH")), "Detects flush ";
    ok RoyalFlush ~~ Deal("TH JH QH KH AH") , "Detects royal flush ";
    ok Deal("5H 5C 6S 7S KD") <=> Deal("2C 3S 8S 8D TD") ~~ Less,"Player 2 wins [1]";
    ok Deal("5D 8C 9S JS AC") <=> Deal("2C 5C 7D 8S QH") ~~ More, "Player 1 wins [2]";
    ok Deal("2D 9C AS AH AC") <=> Deal("3D 6D 7D TD QD") ~~ Less, "Player 2 wins [3]";
    ok Deal("4D 6S 9H QH QC") <=> Deal("3D 6D 7H QD QS") ~~ More, "Player 1 wins [4]";
    ok Deal("2H 2D 4C 4D 4S") <=> Deal("3C 3D 3S 9S 9D") ~~ Same, "Nobody wins [5]";
    ok Deal("7C 5H KC QH JD") <=> Deal("AS KH 4C AD 4S") ~~ Less, "Player 2 wins [6]";
    ok Deal("KS KC 9S 6D 2C") <=> Deal("QH 9D 9H TS TC") ~~ Less, "Problem [1]";
    ok Deal("TS QH 6C 8H TH") <=> Deal("5H 3C 3H 9C 9D") ~~ Less, "Problem [2]";
    ok Deal("AH QC JC 4C TC") <=> Deal("8C 2H TS 2C 7D") ~~ Less, "Problem [3]";
    ok Deal("7C KS 6S 5S 2S") <=> Deal("2D TC 2H 5H QS") ~~ Less, "Problem [4]";
    ok Deal("JC TH 4S 6S JD") <=> Deal("2D 4D 6C 3D 4C") ~~ More, "Problem [5]";
    done;
}

# vim: expandtab shiftwidth=4 ft=perl6
