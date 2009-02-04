# Makefile creator in Perl 6, reads Makefile.in and writes Makefile.
# In this directory, Use your values of /my/ to run either:
#   '/my/perl6 Makefile.p6' or '/my/parrot /my/perl6.pbc Makefile.p6'

use v6;

say "\nHi, this is Makefile.p6 getting ready to make your Makefile.\n";

# Determine how this Makefile.p6 was invoked, so that the same way can
# be used in the Makefile variables.
# These are the ways amenable to this script:
# 1. /path/to/parrot/parrot /path/to/rakudo/perl6.pbc Makefile.p6
# 2. # use pbc_to_exe to make /path/to/rakudo/perl6, then
#    /path/to/rakudo/perl6 Makefile.p6
# 3. # do 2., then sudo ln -s /path/to/rakudo/perl6 <any dir in search path>, then
#    perl6 Makefile.p6
# 4. # do alias perl6='/path/to/parrot/parrot /path/to/rakudo/perl6.pbc', then
#    perl6 Makefile.p6

# Are there other ways to run Rakudo? Please tell the author.

# Operating System
# One day we shall not have to do this any more, when Rakudo gives the
# required information in special variables such as $*PROG.
my $ps_command;
given %*VM<config><osname> {
    when 'linux' | 'darwin' {
        $ps_command = 'ps o args';
    }
    when 'win32' {
        say "Sorry, not working (yet) on Windows";
        say "Cannot continue.";
        exit(1);
    }
    default {
        say "Sorry, I don't know os '{%*VM<config><osname>}'";
        say "Please report this. Cannot continue.";
        exit(2);
    }
}
say "osname     = {%*VM<config><osname>}";

# Identify the current process executable and arguments.
# Workaround with 'ps' because $*PROG not yet implemented as at r36318.
my @ps = qx($ps_command).split("\n");         # all procs and their args
my @makeproc = grep( { $_ ~~ / Makefile.p6 $ / }, @ps);  # find Makefile
if @makeproc.elems != 1 {
    say "Strange, cannot find myself in your process list.";
    say "Here's what your '$ps_command' reported:";
    say @ps.join("\n");
    say "I give up.";
    exit(3);
}
if @makeproc[0] !~~ / (.*) Makefile.p6 $ / {
    say "Cannot read command line. It says:";
    say @makeproc[0];
    exit(4);
}

# The executable running this script, to be written in Makefile.
#my $perl6 = $0;        # $*PROG one day...
my $perl6 = $0.trim;   # $*PROG one day...
say "PERL6      = $perl6";

# PARROT needed by dependencies to check whether to do .pm -> .pir
# recompiles.
my $parrot = %*VM<config><prefix> ~ '/parrot';
say "PARROT     = $parrot";

# RAKUDO_DIR may be in or out of the parrot tree. Needed for Test.pm.
my $rakudo_dir = $perl6.subst( $parrot, '' ); # remove possible parrot
$rakudo_dir .= subst( / ^ <.ws> /, '' ); # remove possible leading spaces
$rakudo_dir .= subst( / \/perl6[\.pbc]?<.ws> $ /, '' ); # remove trailing perl6
say "RAKUDO_DIR = $rakudo_dir";

# The perl6-examples/lib/SVG directory is one level below lib/, so trim
# off the last / and directory name off PWD to make PERL6LIB.
my $perl6lib = %*ENV<PWD>.subst( / \/ <-[/]>+ $ /, '' ); # trim slash then non slash at end
say "PERL6LIB   = $perl6lib";

# The perl6-examples/bin directory is a sibling of PERL6LIB
my $bin_dir = $perl6lib.subst( '/lib', '/bin' );
say "BIN_DIR    = $bin_dir";

# Read Makefile.in, edit, write Makefile
my $maketext = slurp( 'Makefile.in' );
$maketext .= subst( 'Makefile.in', 'Makefile' );
$maketext .= subst( 'To be read', 'Written' );
$maketext .= subst( '<VARIABLES> will be replaced', 'Variables defined' );
$maketext .= subst( '<PARROT>', $parrot );
$maketext .= subst( '<PERL6>', $perl6 );
$maketext .= subst( '<RAKUDO_DIR>', $rakudo_dir );
$maketext .= subst( '<PERL6LIB>', $perl6lib );
$maketext .= subst( '<BIN_DIR>', $bin_dir );
squirt( 'Makefile', $maketext );

# Job done.
say "\nAll done. You can now use 'make', 'make help' and so on.\n";

# The opposite of slurp
sub squirt( Str $filename, Str $text ) {
    my $handle = open( $filename, :w );    # should check for success
    $handle.print: $text;
    $handle.close;
}

# inefficient workaround - replace when Rakudo gets qx{} or `backtick`.
sub qx( $command ) {
    my Str $tempfile = "/tmp/rakudo_svg_tiny_makefile_qx.tmp";
    my Str $fullcommand = "$command >$tempfile";
    run $fullcommand;
    my Str $result = slurp( $tempfile );
    unlink $tempfile;
    return $result;
}

=begin pod

=head1 NAME
Makefile.p6 - convert Makefile.in to Makefile with local settings

=head1 TODO


=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @flashmail.com).

=end pod
