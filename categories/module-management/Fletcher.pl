use v6;

=begin pod

=TITLE Unique module names with the Fletcher-16 hash

=AUTHOR Daniel Carrera

A sketch program to compute unique file names for Perl modules based
on the Fletcher-16 hash.

License: Public Domain

Example: Foo::Bar-auth:92de-ver:1.2.0--0

Explanation:

The module name (Foo::Bar) is URL-encoded. After that, we add all metadata
sorted by key. Version numbers are left intact. Other metadata is hashed
with Fletcher-16.

Lastly, a counter is added at the end. If two different modules get the
exact same name (extremely unlikely) we use a counter to distinguish them.

=end pod

my @modules = (
    {name => "Foo::Bar", meta => {auth=>'mailto:dave@example.com', ver=>'1.2.0'}},
    {name => "Foo::動", meta => {auth=>'mailto:chang@example.com', ver=>'2.1.3'}}
);

say filename(@modules[0]<name>,@modules[0]<meta>);
say filename(@modules[1]<name>,@modules[1]<meta>);

sub filename($module,%meta) {
    my $filename = strencode($module);
    for %meta.sort {
        my $v = .value ~~ m/[\D & <-[.]>]/ ?? fletcher16(.value) !! .value;
        $filename ~= "-" ~ .key ~ ":$v";
    }
    return $filename ~ "--0";
}

sub strencode($str) {
    return $str.subst(/(<-alpha -[:]>)/,{ charencode($0) },:g);
}

sub charencode($char) {
    my ($url,$hex) = ('',$char.fmt("%02x"));

    while $hex.chars {
        $url ~= '%' ~ $hex.substr(0,2);
        $hex = $hex.substr(2);
    }
    return $url;
}

sub fletcher16($str) {
    my ($A,$B) = (0,0);
    for map { .ord }, $str.comb -> $val {
        if $val > 255 {
            $A = ($A + $val div 255) % 255;
            $B = ($B + $A) % 255;
        }
        $A = ($A + $val % 255) % 255;
        $B = ($B + $A) % 255;
    }
    return ($A*256 + $B).fmt("%04x");
}

# vim: expandtab shiftwidth=4 ft=perl6
