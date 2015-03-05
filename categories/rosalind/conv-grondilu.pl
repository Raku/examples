use v6;

my $a = "186.07931 287.12699 548.20532 580.18077 681.22845 706.27446 782.27613 968.35544 968.35544";
my $b = "101.04768 158.06914 202.09536 318.09979 419.14747 463.17369";

my %conv; %conv{$_}++ for $a.split(/\s+/) X- $b.split(/\s+/);
.say for max(:by(*.value), %conv).kv.reverse;

# vim: expandtab shiftwidth=4 ft=perl6
