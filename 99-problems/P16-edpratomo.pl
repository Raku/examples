use v6;

sub drop(@ary, $n) {
  gather for 1 .. @ary.elems -> $i { take @ary[$i - 1] if $i % $n }
}

drop(<A B C D E F G H I K>, 3).perl.say;
