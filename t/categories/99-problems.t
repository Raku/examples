use v6;

use Test;

my $base-dir = "categories/99-problems";
my %expected-output = expected-output;
my @script-names = %expected-output.keys.sort;

for @script-names -> $name {
    my $script-path = $base-dir ~ "/" ~ $name;
    my $output = qqx{perl6 $script-path};

    if $name eq "P23-topo.pl" {
        is($output.chomp.split(' ').elems, 3, $name);
        for $output.chomp.split(' ') -> $element {
            ok($element ∈ "a".."e", $name);
        }
    }
    elsif $name eq "P24-topo.pl" {
        is($output.chomp.split(' ').elems, 6, $name);
        for $output.chomp.split(' ') -> $number {
            ok(Int($number) ∈ 1..49, $name);
        }
    }
    elsif $name eq "P25-topo.pl" {
        is($output.chomp.substr(1,*-1).split(' ').list.sort, %expected-output{$name}.chomp.split(' ').sort, $name);
        isnt($output, <a b c d e>, $name);
    }
    elsif $name eq "P26-topo.pl" {
        is($output.trim-trailing, %expected-output{$name}.trim-trailing, $name);
    }
    else {
        is($output, %expected-output{$name}, $name);
    }
}

done-testing;

#| return hash of expected output for each example script
sub expected-output {
    my %expected-output;
    %expected-output{"P01-scottp.pl"} = q:to/END/;
    F
    D
    Z
    Z
    END

    %expected-output{"P01-topo.pl"} = q:to/END/;
    e
    END

    %expected-output{"P02-scottp.pl"} = q:to/END/;
    E F
    c d
    END

    %expected-output{"P02-topo.pl"} = q:to/END/;
    d e
    END

    %expected-output{"P03-scottp.pl"} = q:to/END/;
    C
    c
    END

    %expected-output{"P03-topo.pl"} = q:to/END/;
    e
    END

    %expected-output{"P04-scottp.pl"} = q:to/END/;
    4
    4
    2
    END

    %expected-output{"P04-topo.pl"} = q:to/END/;
    5
    END

    %expected-output{"P05-scottp.pl"} = q:to/END/;
    D C B A
    ("D", "C", "B", "A")
    END

    %expected-output{"P05-topo.pl"} = q:to/END/;
    e d c b a
    END

    %expected-output{"P06-ajs.pl"} = q:to/END/;
    a b c d E is a palindrome
    a b c b a is a palindrome
    a b b E is a palindrome
    E b b a is a palindrome
    a b b a is a palindrome
    a is a palindrome
    a a is a palindrome
    E a is a palindrome
    END

    %expected-output{"P06-scottp.pl"} = q:to/END/;
    A B C B A is a palindrome
    END

    %expected-output{"P06-topo.pl"} = q:to/END/;
    False
    True
    END

    %expected-output{"P07-eric256.pl"} = q:to/END/;
    ("a", "b", "c", "d", "e")
    END

    %expected-output{"P07-topo.pl"} = q:to/END/;
    (1, 2, [3, 4], 5)
    Flattened:
    (1, 2, 3, 4, 5)
    END

    %expected-output{"P07-viklund.pl"} = q:to/END/;
    (1, 2, 3, 4, 5)
    END

    %expected-output{"P08-eric256.pl"} = q:to/END/;
    ["a", "b", "c", "a", "d", "e"]
    END

    %expected-output{"P08-topo.pl"} = q:to/END/;
    a b c b d e
    END

    %expected-output{"P08-viklund.pl"} = q:to/END/;
    ("a", "b", "c", "a", "d", "e")
    END

    %expected-output{"P09-rje.pl"} = q:to/END/;
    [["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"]]
    END

    %expected-output{"P09-scottp.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    [["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"]]
    END

    %expected-output{"P09-topo.pl"} = q:to/END/;
    (["a", "a", "a", "a", "a"], ["b", "b"], ["c"], ["b"], ["d"], ["e", "e"])
    END

    %expected-output{"P09-unobe.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    (["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"])
    END

    %expected-output{"P10-scottp.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    [[4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"]]
    END

    %expected-output{"P10-topo.pl"} = q:to/END/;
    ([5, "a"], [2, "b"], [1, "c"], [1, "b"], [1, "d"], [2, "e"])
    END

    %expected-output{"P10-unobe.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    ([4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"])
    END

    %expected-output{"P11-topo.pl"} = q:to/END/;
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])
    END

    %expected-output{"P11-unobe.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])
    END

    %expected-output{"P12-rhebus.pl"} = q:to/END/;
    4 a b 2 c 2 a d 4 e
    ("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")
    END

    %expected-output{"P12-topo.pl"} = q:to/END/;
    ("a", "a", "a", "a", "a", "b", "b", "c", "b", "d", "e", "e")
    END

    %expected-output{"P12-unobe.pl"} = q:to/END/;
    [["4", "a"], "b", ["2", "c"], ["2", "a"], "d", ["4", "e"]]
    ["a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e"]
    END

    %expected-output{"P13-rhebus.pl"} = q:to/END/;
    a a a a b c c a a d e e e e
    ([4, "a"],)
    END

    %expected-output{"P13-topo.pl"} = q:to/END/;
    ([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"])
    END

    %expected-output{"P13-viklund.pl"} = q:to/END/;
    [[4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"]]
    END

    %expected-output{"P14-scottp.pl"} = q:to/END/;
    a a b b c c c c d d
    END

    %expected-output{"P14-topo.pl"} = q:to/END/;
    a a b b c c c c d d e e
    END

    %expected-output{"P14-viklund.pl"} = q:to/END/;
    ("a", "a", "b", "b", "c", "c", "c", "c", "d", "d")
    END

    %expected-output{"P15-rhebus.pl"} = q:to/END/;
    a a a b b b c c c
    END

    %expected-output{"P15-topo.pl"} = q:to/END/;
    a a a b b b c c c c c c d d d e e e
    END

    %expected-output{"P15-unobe.pl"} = q:to/END/;
    ["a", "b", "c"]
    ("a", "a", "a", "b", "b", "b", "c", "c", "c")
    END

    %expected-output{"P16-edpratomo.pl"} = q:to/END/;
    ("A", "B", "D", "E", "G", "H", "K")
    END

    %expected-output{"P16-topo.pl"} = q:to/END/;
    a b d e g h j k m n
    END

    %expected-output{"P17-topo.pl"} = q:to/END/;
    (["a", "a", "a", "a", "a", "a", "a", "a"], ["a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a"])
    END

    %expected-output{"P17-unobe.pl"} = q:to/END/;
    ["a", "b", "c", "d", "e", "f", "g", "h", "i", "k"]
    ($["a", "b", "c"], $["d", "e", "f", "g", "h", "i", "k"])
    END

    %expected-output{"P18-topo.pl"} = q:to/END/;
    b c d
    END

    %expected-output{"P19-topo.pl"} = q:to/END/;
    ["d", "e", "f", "g", "a", "b", "c"]
    ["e", "f", "g", "a", "b", "c", "d"]
    END

    %expected-output{"P20-rhebus.pl"} = q:to/END/;
    a c d
    a c d
    a d
    a c d
    a c d
    END

    %expected-output{"P20-topo.pl"} = q:to/END/;
    a b c e
    END

    %expected-output{"P21-scottp.pl"} = q:to/END/;
    a alfa b c d
    a alfa b c d
    a alfa b c d
    END

    %expected-output{"P21-topo.pl"} = q:to/END/;
    a alfa b c d
    END

    %expected-output{"P22-scottp.pl"} = q:to/END/;
    4 5 6 7 8 9
    4 5 6 7 8 9
    7 6 5 4 3 2
    END

    %expected-output{"P22-topo.pl"} = q:to/END/;
    (5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20)
    (20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5)
    END

    %expected-output{"P23-topo.pl"} = q:to/END/;
    b c a
    END

    %expected-output{"P24-topo.pl"} = q:to/END/;
    33 48 10 3 4 44
    END

    %expected-output{"P25-topo.pl"} = q:to/END/;
    e d a b c
    END

    %expected-output{"P26-topo.pl"} = q:to/END/;
    220
    ((g h i) (g h j) (g h k) (g h l) (g i j) (g i k) (g i l) (g j k) (g j l) (g k l) (h i j) (h i k) (h i l) (h j k) (h j l) (h k l) (i j k) (i j l) (i k l) (j k l))
    END

    %expected-output{"P31-rhebus.pl"} = q:to/END/;
    Is 2 prime? yes
    Is 3 prime? yes
    Is 4 prime? no
    Is 5 prime? yes
    Is 6 prime? no
    Is 7 prime? yes
    Is 8 prime? no
    Is 9 prime? no
    Is 10 prime? no
    Is 49 prime? no
    Is 137 prime? yes
    Is 219 prime? no
    Is 1723 prime? yes
    END

    %expected-output{"P32-rhebus.pl"} = q:to/END/;
    9
    9
    9
    4
    9
    9
    END

    %expected-output{"P33-rhebus.pl"} = q:to/END/;
    True
    True
    True
    True
    True
    True
    True
    True
    True
    True
    False
    False
    False
    False
    False
    False
    False
    False
    False
    False
    False
    END

    %expected-output{"P34-rhebus.pl"} = q:to/END/;
    phi(1): 1
    phi(2): 1
    phi(3): 2
    phi(4): 2
    phi(5): 4
    phi(6): 2
    phi(7): 6
    phi(8): 4
    phi(9): 6
    phi(10): 4
    phi(11): 10
    phi(12): 4
    phi(13): 12
    phi(14): 6
    phi(15): 8
    phi(16): 8
    phi(17): 16
    phi(18): 6
    phi(19): 18
    phi(20): 8
    phi(1): 1
    phi(2): 1
    phi(3): 2
    phi(4): 2
    phi(5): 4
    phi(6): 2
    phi(7): 6
    phi(8): 4
    phi(9): 6
    phi(10): 4
    phi(11): 10
    phi(12): 4
    phi(13): 12
    phi(14): 6
    phi(15): 8
    phi(16): 8
    phi(17): 16
    phi(18): 6
    phi(19): 18
    phi(20): 8
    END

    %expected-output{"P35-rhebus.pl"} = q:to/END/;
    2
    3
    2 2
    5
    2 3
    7
    2 2 2
    3 3
    2 5
    11
    2 2 3
    13
    2 7
    3 5
    2 2 2 2
    17
    2 3 3
    19
    2 2 5
    3 3 5 7
    1723
    END

    %expected-output{"P36-ovid.pl"} = q:to/END/;
    Prime factors of 2 are: {"2" => 1}
    Prime factors of 17 are: {"17" => 1}
    Prime factors of 53 are: {"53" => 1}
    Prime factors of 90 are: {"2" => 1, "3" => 2, "5" => 1}
    Prime factors of 94 are: {"2" => 1, "47" => 1}
    Prime factors of 200 are: {"2" => 3, "5" => 2}
    Prime factors of 289 are: {"17" => 2}
    Prime factors of 62710561 are: {"7919" => 2}
    END

    %expected-output{"P36-rhebus.pl"} = q:to/END/;
    ()
    (2 => 1,)
    (3 => 1,)
    (2 => 2,)
    (5 => 1,)
    (2 => 1, 3 => 1)
    (7 => 1,)
    (2 => 3,)
    (3 => 2,)
    (2 => 1, 5 => 1)
    (11 => 1,)
    (2 => 2, 3 => 1)
    (13 => 1,)
    (2 => 1, 7 => 1)
    (3 => 1, 5 => 1)
    (2 => 4,)
    (17 => 1,)
    (2 => 1, 3 => 2)
    (19 => 1,)
    (2 => 2, 5 => 1)
    (3 => 2, 5 => 1, 7 => 1)
    (1723 => 1,)
    END

    %expected-output{"P37-rhebus.pl"} = q:to/END/;
    phi(1): 1
    phi(2): 1
    phi(3): 2
    phi(4): 2
    phi(5): 4
    phi(6): 2
    phi(7): 6
    phi(8): 4
    phi(9): 6
    phi(10): 4
    phi(11): 10
    phi(12): 4
    phi(13): 12
    phi(14): 6
    phi(15): 8
    phi(16): 8
    phi(17): 16
    phi(18): 6
    phi(19): 18
    phi(20): 8
    144
    phi2(315): 144
    END

    %expected-output{"P39-rhebus.pl"} = q:to/END/;
    11 13 17 19
    3 5 17 257 65537
    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
    END

    %expected-output{"P40-rhebus.pl"} = q:to/END/;
    5 23
    5 31
    5 47
    3 107
    7 62710553
    END

    %expected-output{"P41-rhebus.pl"} = q:to/END/;
    10 = 3 + 7
    12 = 5 + 7
    14 = 3 + 11
    16 = 3 + 13
    18 = 5 + 13
    20 = 3 + 17
    98 = 19 + 79
    122 = 13 + 109
    124 = 11 + 113
    126 = 13 + 113
    128 = 19 + 109
    148 = 11 + 137
    150 = 11 + 139
    190 = 11 + 179
    192 = 11 + 181
    208 = 11 + 197
    210 = 11 + 199
    212 = 13 + 199
    220 = 23 + 197
    222 = 11 + 211
    224 = 13 + 211
    250 = 11 + 239
    252 = 11 + 241
    292 = 11 + 281
    294 = 11 + 283
    302 = 19 + 283
    304 = 11 + 293
    306 = 13 + 293
    308 = 31 + 277
    326 = 13 + 313
    328 = 11 + 317
    330 = 13 + 317
    332 = 19 + 313
    346 = 29 + 317
    348 = 11 + 337
    368 = 19 + 349
    398 = 19 + 379
    410 = 13 + 397
    418 = 17 + 401
    420 = 11 + 409
    430 = 11 + 419
    432 = 11 + 421
    458 = 19 + 439
    476 = 13 + 463
    478 = 11 + 467
    480 = 13 + 467
    488 = 31 + 457
    500 = 13 + 487
    518 = 19 + 499
    520 = 11 + 509
    522 = 13 + 509
    532 = 11 + 521
    534 = 11 + 523
    536 = 13 + 523
    538 = 17 + 521
    540 = 17 + 523
    542 = 19 + 523
    556 = 47 + 509
    558 = 11 + 547
    586 = 17 + 569
    588 = 11 + 577
    628 = 11 + 617
    630 = 11 + 619
    632 = 13 + 619
    640 = 23 + 617
    642 = 11 + 631
    670 = 11 + 659
    672 = 11 + 661
    674 = 13 + 661
    692 = 19 + 673
    700 = 17 + 683
    702 = 11 + 691
    710 = 19 + 691
    718 = 17 + 701
    720 = 11 + 709
    728 = 19 + 709
    752 = 13 + 739
    770 = 13 + 757
    782 = 13 + 769
    784 = 11 + 773
    786 = 13 + 773
    788 = 19 + 769
    796 = 23 + 773
    798 = 11 + 787
    806 = 19 + 787
    808 = 11 + 797
    810 = 13 + 797
    820 = 11 + 809
    822 = 11 + 811
    838 = 11 + 827
    840 = 11 + 829
    848 = 19 + 829
    850 = 11 + 839
    852 = 13 + 839
    854 = 31 + 823
    872 = 13 + 859
    874 = 11 + 863
    876 = 13 + 863
    878 = 19 + 859
    896 = 13 + 883
    898 = 11 + 887
    900 = 13 + 887
    902 = 19 + 883
    904 = 17 + 887
    906 = 19 + 887
    908 = 31 + 877
    920 = 13 + 907
    928 = 17 + 911
    930 = 11 + 919
    938 = 19 + 919
    962 = 43 + 919
    964 = 11 + 953
    966 = 13 + 953
    968 = 31 + 937
    992 = 73 + 919
    END

    %expected-output{"P91-edpratomo.pl"} = q:to/END/;
    FOUND: [0 => 0, 1 => 2, 0 => 4, 2 => 3, 4 => 4, 3 => 2, 4 => 0, 2 => 1, 0 => 2, 1 => 0, 3 => 1, 4 => 3, 2 => 4, 0 => 3, 1 => 1, 3 => 0, 4 => 2, 3 => 4, 1 => 3, 0 => 1, 2 => 0, 4 => 1, 2 => 2, 1 => 4, 3 => 3]
    END

    return %expected-output;
}

# vim: expandtab shiftwidth=4 ft=perl6
