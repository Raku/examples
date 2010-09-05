use v6;

# Specification:
#   P16 (**) Drop every N'th element from a list.
# Example:
# > say ~drop(<a b c d e f g h i k>, 3);
# a b d e g h k


sub drop(@ary, $n) {
  gather for 1 .. @ary.elems -> $i { take @ary[$i - 1] if $i % $n }
}

drop(<A B C D E F G H I K>, 3).perl.say;
