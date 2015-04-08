use v6;

use Test;

my $base-dir = "categories/99-problems";
my %expected-output = expected-output;
my @script-names = %expected-output.keys;

for @script-names -> $name {
    my $script-path = $base-dir ~ "/" ~ $name;
    my $output = qqx{perl6 $script-path};
    is($output, %expected-output{$name}, $name);
}

done;

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

    return %expected-output;
}

=begin data
categories/99-problems/P02-scottp.pl
E F
c d

categories/99-problems/P02-topo.pl
d e

categories/99-problems/P03-scottp.pl
C
c

categories/99-problems/P03-topo.pl
e

categories/99-problems/P04-scottp.pl
4
4
2

categories/99-problems/P04-topo.pl
5

categories/99-problems/P05-scottp.pl
D C B A
("D", "C", "B", "A").list

categories/99-problems/P05-topo.pl
e d c b a

categories/99-problems/P06-ajscogo.pl
a b c d E is a palindrome
a b c b a is a palindrome
a b b E is a palindrome
E b b a is a palindrome
a b b a is a palindrome
a is a palindrome
a a is a palindrome
E a is a palindrome

categories/99-problems/P06-scottp.pl
A B C B A is a palindrome

categories/99-problems/P06-topo.pl
e d c b a
a b c b a

categories/99-problems/P07-eric256.pl
Array.new([], "a", [], "b", [], "c", "d", "e")

categories/99-problems/P07-topo.pl
Array.new(1, 2, [3, 4], 5)
Flattened:
(1, 2, 3, 4, 5).list

categories/99-problems/P07-viklund.pl
(1, 2, 3, 4, 5).list

categories/99-problems/P08-eric256.pl
Array.new("a", "b", "c", "a", "d", "e")

categories/99-problems/P08-topo.pl
a b c b d e

categories/99-problems/P08-viklund.pl
Array.new("a", "b", "c", "a", "d", "e")

categories/99-problems/P09-rje.pl
Array.new(["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"])

categories/99-problems/P09-scottp.pl
a a a a b c c a a d e e e e
Array.new(["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"])

categories/99-problems/P09-topo.pl
(["a", "a", "a", "a", "a"], ["b", "b"], ["c"], ["b"], ["d"], ["e", "e"]).list

categories/99-problems/P09-unobe.pl
a a a a b c c a a d e e e e
(["a", "a", "a", "a"], ["b"], ["c", "c"], ["a", "a"], ["d"], ["e", "e", "e", "e"]).list

categories/99-problems/P10-scottp.pl
a a a a b c c a a d e e e e
Array.new([4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"])

categories/99-problems/P10-topo.pl
([Bool::False; 5, "a"], [Bool::False; 2, "b"], [Bool::False; 1, "c"], [Bool::False; 1, "b"], [Bool::False; 1, "d"], [0; 2, "e"]).list

categories/99-problems/P10-unobe.pl
a a a a b c c a a d e e e e
([4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"]).list

categories/99-problems/P11-topo.pl
(Bool::False, [4, "a"], Bool::False, "b", Bool::False, [2, "c"], Bool::False, [2, "a"], Bool::False, "d", 0, [4, "e"]).list

categories/99-problems/P11-unobe.pl
a a a a b c c a a d e e e e
([4, "a"], "b", [2, "c"], [2, "a"], "d", [4, "e"]).list

categories/99-problems/P12-rhebus.pl
4 a b 2 c 2 a d 4 e
("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e").list

categories/99-problems/P12-topo.pl
("a", "a", "a", "a", "a", "b", "b", "c", "b", "d", "e", "e").list

categories/99-problems/P12-unobe.pl
Array.new(["4", "a"], "b", ["2", "c"], ["2", "a"], "d", ["4", "e"])
Array.new("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")

categories/99-problems/P13-rhebus.pl
a a a a b c c a a d e e e e
([4, "a"],).list

categories/99-problems/P13-topo.pl
(Bool::False, [4, "a"], Bool::False, "b", Bool::False, [2, "c"], Bool::False, [2, "a"], Bool::False, "d", 0, [4, "e"]).list

categories/99-problems/P13-viklund.pl
Array.new([4, "a"], [1, "b"], [2, "c"], [2, "a"], [1, "d"], [4, "e"])

categories/99-problems/P14-scottp.pl
a a b b c c c c d d

categories/99-problems/P14-topo.pl
a a b b c c c c d d e e

categories/99-problems/P14-viklund.pl
("a", "a", "b", "b", "c", "c", "c", "c", "d", "d").list

categories/99-problems/P15-rhebus.pl
a a a b b b c c c

categories/99-problems/P15-topo.pl
a a a b b b c c c c c c d d d e e e

categories/99-problems/P15-unobe.pl
Array.new("a", "b", "c")
("a", "a", "a", "b", "b", "b", "c", "c", "c").list

categories/99-problems/P16-edpratomo.pl
("A", "B", "D", "E", "G", "H", "K").list

categories/99-problems/P16-topo.pl
a b d e g h j k m n

categories/99-problems/P17-topo.pl
(["a", "a", "a", "a", "a", "a", "a", "a"], ["a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a", "a"]).list

categories/99-problems/P17-unobe.pl
Array.new("a", "b", "c", "d", "e", "f", "g", "h", "i", "k")
(["a", "b", "c"], ["d", "e", "f", "g", "h", "i", "k"])

categories/99-problems/P18-topo.pl
b c d

categories/99-problems/P19-topo.pl
Array.new("d", "e", "f", "g", "a", "b", "c")
Array.new("e", "f", "g", "a", "b", "c", "d")

categories/99-problems/P20-rhebus.pl
a c d
a c d
a d
a c d
a c d

categories/99-problems/P20-topo.pl
a b c e

categories/99-problems/P21-scottp.pl
a alfa b c d
a alfa b c d
a alfa b c d

categories/99-problems/P21-topo.pl
a alfa b c d

categories/99-problems/P22-scottp.pl
4 5 6 7 8 9
4 5 6 7 8 9
7 6 5 4 3 2

categories/99-problems/P22-topo.pl
(5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20).list
(20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5).list

categories/99-problems/P23-topo.pl
b c a

categories/99-problems/P24-topo.pl
33 48 10 3 4 44

categories/99-problems/P25-topo.pl
e d a b c

categories/99-problems/P26-topo.pl
a b c a b d a b e a b f a b g a b h a b i a b j a b k a c d a c e a c f a c g a c h a c i a c j a c k a d e a d f a d g a d h a d i a d j a d k a e f a e g a e h a e i a e j a e k a f g a f h a f i a f j a f k a g h a g i a g j a g k a h i a h j a h k a i j a i k a j k b c d b c e b c f b c g b c h b c i b c j b c k b d e b d f b d g b d h b d i b d j b d k b e f b e g b e h b e i b e j b e k b f g b f h b f i b f j b f k b g h b g i b g j b g k b h i b h j b h k b i j b i k b j k c d e c d f c d g c d h c d i c d j c d k c e f c e g c e h c e i c e j c e k c f g c f h c f i c f j c f k c g h c g i c g j c g k c h i c h j c h k c i j c i k c j k d e f d e g d e h d e i d e j d e k d f g d f h d f i d f j d f k d g h d g i d g j d g k d h i d h j d h k d i j d i k d j k e f g e f h e f i e f j e f k e g h e g i e g j e g k e h i e h j e h k e i j e i k e j k f g h f g i f g j f g k f h i f h j f h k f i j f i k f j k g h i g h j g h k g i j g i k g j k h i j h i k h j k i j k

categories/99-problems/P31-rhebus.pl
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

categories/99-problems/P32-rhebus.pl
9
9
9
4
9
9

categories/99-problems/P33-rhebus.pl
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

categories/99-problems/P34-rhebus.pl
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

categories/99-problems/P35-rhebus.pl
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

categories/99-problems/P36-ovid.pl
Prime factors of 17 are: {"17" => 1}
Prime factors of 53 are: {"53" => 1}
Prime factors of 90 are: ("2" => 1, "3" => 2, "5" => 1).hash
Prime factors of 94 are: ("2" => 1, "47" => 1).hash
Prime factors of 200 are: ("2" => 3, "5" => 2).hash
Prime factors of 289 are: ("17" => 2).hash
Prime factors of 62710561 are: ("7919" => 2).hash

categories/99-problems/P36-rhebus.pl
().list
(2 => 1,).list
(3 => 1,).list
(2 => 2,).list
(5 => 1,).list
(2 => 1, 3 => 1).list
(7 => 1,).list
(2 => 3,).list
(3 => 2,).list
(2 => 1, 5 => 1).list
(11 => 1,).list
(2 => 2, 3 => 1).list
(13 => 1,).list
(2 => 1, 7 => 1).list
(3 => 1, 5 => 1).list
(2 => 4,).list
(17 => 1,).list
(2 => 1, 3 => 2).list
(19 => 1,).list
(2 => 2, 5 => 1).list
(3 => 2, 5 => 1, 7 => 1).list
(1723 => 1,).list

categories/99-problems/P37-rhebus.pl
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

categories/99-problems/P39-rhebus.pl
11 13 17 19
3 5 17 257 65537
1 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97

categories/99-problems/P40-rhebus.pl
5 23
5 31
5 47
3 107

categories/99-problems/P41-rhebus.pl
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

categories/99-problems/P91-edpratomo.pl
FOUND: Array.new(0 => 0, 1 => 2, 0 => 4, 2 => 3, 4 => 4, 3 => 2, 4 => 0, 2 => 1, 3 => 3, 4 => 1, 2 => 0, 0 => 1, 1 => 3, 3 => 4, 4 => 2, 3 => 0, 1 => 1, 0 => 3, 2 => 4, 4 => 3, 3 => 1, 1 => 0, 2 => 2, 1 => 4, 0 => 2)

c
=end data

# vim: expandtab shiftwidth=4 ft=perl6
