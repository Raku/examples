# Configure.pm 

say "\nConfigure.pm is preparing to make your Makefile.\n";

# Determine how this Configure.p6 was invoked, to write the same paths
# and executables into the Makefile variables. The variables are:
# PERL6       how to execute a Perl 6 script
# PERL6LIB    initial value of @*INC, where use <module> searches
# PERL6BIN    directory where executables such as prove reside
# RAKUDO_DIR  (deprecated) currently the location of Rakudo's Test.pm

my $parrot_dir = %*VM<config><build_dir>;
my $rakudo_dir;
my $perl6;
# There are now just two possible relationships between the parrot and
# rakudo directories: rakudo/parrot or parrot/languages/rakudo
if $parrot_dir ~~ / <parrot_in_rakudo> / {
    # first case, rakudo/parrot for example if installed using new
    # 'git clone ...rakudo.git' then 'perl Configure.pl --gen-parrot'
    $rakudo_dir = $parrot_dir.subst( / '/parrot' $ /, ''); #'
}
elsif "$parrot_dir/languages/rakudo" ~~ :d {
    # second case, parrot/languages/rakudo if installed the old way
    $rakudo_dir = "$parrot_dir/languages/rakudo";
}
else {
    say "PARROT_DIR unexpected $parrot_dir";
    exit(1);
}
if "$rakudo_dir/perl6" ~~ :f or "$rakudo_dir/perl6.exe" ~~ :f {
    $perl6 = "$rakudo_dir/perl6";  # the fake executable from pbc_to_exe
}
else {
    $perl6 = "$parrot_dir/parrot $rakudo_dir/perl6.pbc";
}

say "PERL6       $perl6";
# The perl6-examples/lib/SVG directory is one level below lib/, so trim
# off the last / and directory name off PWD to make PERL6LIB.
my $perl6lib = %*ENV<PWD>.subst( / \/ <-[/]>+ $ /, '' ); # trim slash then non slash at end
say "PERL6LIB    $perl6lib";
# The perl6-examples/bin directory is a sibling of PERL6LIB
my $perl6bin = $perl6lib.subst( '/lib', '/bin' );
say "PERL6BIN    $perl6bin";
say "RAKUDO_DIR  $rakudo_dir";

# Read Makefile.in, edit, write Makefile
my $maketext = slurp( 'Makefile.in' );
$maketext .= subst( 'Makefile.in', 'Makefile' );
$maketext .= subst( 'To be read', 'Written' );
$maketext .= subst( 'replaces <TOKENS>', 'defined these' );
$maketext .= subst( '<PERL6>',      $perl6 );
$maketext .= subst( '<PERL6LIB>',   $perl6lib );
$maketext .= subst( '<PERL6BIN>',   $perl6bin );
$maketext .= subst( '<RAKUDO_DIR>', $rakudo_dir );
squirt( 'Makefile', $maketext );

# Job done.
say "\nMakefile is ready, running 'make' on it.";
run "make";
say "Configure and 'make' are complete. Use 'make help' to view other options.";
say "";


# The opposite of slurp
sub squirt( Str $filename, Str $text ) {
    my $handle = open( $filename, :w )
        or die $!;
    $handle.print: $text;
    $handle.close;
}

# This Configure.pm can work with the following ways of starting up:
# 1. The explicit way Parrot runs any Parrot Byte Code:
#    my/parrot/parrot my/rakudo/perl6.pbc Configure.p6
# 2. The Rakudo "Fake Executable" made by pbc_to_exe:
#    my/rakudo/perl6 Configure.p6
# The rest are variations of 1. and 2. to shorten the command line:
# 3. A shell script perl6 for 1. 'my/parrot/parrot my/rakudo/perl6.pbc $*':
#    my/perl6 Configure.p6    # or 'perl6 Configure.p6' with search path
# 4. A shell alias for 1. perl6='my/parrot/parrot my/rakudo/perl6.pbc':
#    perl6 Configure.p6
# 5. A symbolic link for 2. 'sudo ln -s /path/to/rakudo/perl6 /bin':
#    perl6 Configure.p6

# Are there other ways to execute Perl 6 scripts? Please tell the author.

regex parrot_in_rakudo { ( .* '/rakudo' ) '/parrot' }
# regex rakudo_in_parrot { .* '/parrot/languages/rakudo' }

#regex rakudo_pbc { 'parrot ' <rakudo_dir> '/perl6.pbc Configure.p6' }
#regex rakudo_dir { .* }
#regex rakudo_exe { ( .* 'perl6' ) ' Configure.p6' }

=begin pod

=head1 NAME
Makefile.pm - common code for Makefile builder and runner

=head1 SYNOPSIS
=begin code
perl6 Configure.p6
=end code
Where F<Configure.p6> generally has only these lines:
=begin code
# Configure.p6 - installer - see documentation in ../Configure.pm
BEGIN { @*INC.push( '..' ); } use Configure;
=end code

=head1 DESCRIPTION
A Perl module often needs a Makefile to specify how to build, test and
install it. A Makefile must make sense to the Unix C<make> utility.
Makefiles must often be adjusted slightly to alter the context in which
they will work. There are various tools to make Makefiles and this
Configure.p6 and Configure.pm combination run purely in Perl 6.

Configure.p6 resides in the top level directory of the module.
For easier maintenance, Configure.p6 usually contains only the lines
shown in L<doc:#SYNOPSIS> above, namely a comment and one line of code
to pass execution to F<Configure.pm>. It is recommended that any custom
actions required to prepare the module be written in Makefile.in.

Configure.pm reads Makefile.in from the module top level directory,
replaces certain variables marked like <THIS>, and writes the updated
text to Makefile in the same directory. Finally it runs the standard
'make' utility, which builds the first target defined in Makefile.

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @autoexec.demon.nl).

=end pod
