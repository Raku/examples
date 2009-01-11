# Test::Harness for Rakudo (Perl 6)

class Test::Harness {

    sub runtests( Str $perl, @filenames ) {
        my Int $total_test = 0;
        my Int $total_pass = 0;
        my Int $total_fail = 0;
        my Int $total_file = 0;
        my $time_started = time();
        my Int $max_namechars = 1;
        for @filenames -> $name {
            if $name.chars > $max_namechars { $max_namechars = $name.chars; }
        }
        for @filenames -> $name {
            print "$name{'.'x($max_namechars+4-$name.chars)}";
            my @results = qx( "$perl $name" ).split("\n");
            # remove blank lines at the end of qx output (usually two)
            my Int $topindex = @results.end;
            while @results[$topindex] eq '' { @results.pop; $topindex--; }
            # the first line must announce the number of planned tests
            if @results[0] ~~ / <digit>+ <dot> <dot> ( <digit>+ ) / {
                my Int $tests_planned = $0;
                my Int $tests_passed  = 0;
                my Int $tests_failed  = 0;
                my Int $tests_done    = @results.end; # first line says 1..count
                if $tests_done != $tests_planned {
                    say " $tests_planned tests planned, $tests_done done";
                    if $tests_done < $tests_planned {
                        $tests_failed = $tests_planned - $tests_done;
                    }
                    if $tests_done > $tests_planned {
                        $tests_planned = $tests_done;
                    }
                }
                my @failures;
                for 1 .. $tests_done -> $test_number {
                    if @results[$test_number] ~~ / ^ ok <sp> (<digit>+) / {
                        if $0 == $test_number { $tests_passed++; }
                        else {
                            $tests_failed++;
                            say "NOK $test_number/$tests_planned";
                            say @results[$test_number];
                            print "$name{'.'x($max_namechars+4-$name.chars)}";
                        }
                    }
                    else {
                        $tests_failed++;
                        push @failures, @results[$test_number];
                    }
                }
                if $tests_failed == 0 { say "ok"; }
                else {
                    say "# Looks like you failed $tests_failed out of $tests_planned";
                    for @failures { .say; }
                }
                $total_test = $total_test + $tests_planned;
                $total_pass = $total_pass + $tests_passed;
                $total_fail += $tests_failed;
                $total_file++;
            }
            else { say "error - need plan : {@results[0]}"; }
        }
        if $total_fail == 0 { say "All tests successful"; }
        else { say "$total_fail failed, $total_pass passed"; }
        my $realtime = int( time() - $time_started );
        say "Files=$total_file, Tests=$total_test, $realtime wallclock secs";
    }

    # inefficient workaround - remove when Rakudo gets a qx operator
    sub qx( $command ) {
        my $tempfile = "/tmp/rakudo_qx.tmp";
        my $fullcommand = "$command >$tempfile";
        run $fullcommand;
        my $result = slurp( $tempfile );
        unlink $tempfile;
        return $result;
    }

} # class Test::Harness

=begin pod

=head1 NAME
Test::Harness - test harness for Rakudo (Perl 6)

=head1 SYNOPSIS
From the command line...
=begin code
perl6 -e'use Test::Harness; Test::Harness::runtests(@*ARGS);' t/*.t
=end code

=head1 TODO
Pass $perl parameter via %*ENV<HARNESS_PERL> to be compatible with the
Perl 5 interface.

=head1 BUGS
The command line in L<doc:#SYNOPSIS> began to fail with Rakudo r34090
because @*ARGS stopped being populated from the command line if -e was
used. Fortunately using this module via L<doc:prove> still works.

=head1 SEE ALSO
L<doc:prove>

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @flashmail.com).

=end pod
