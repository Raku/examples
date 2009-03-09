# Test::Harness for Rakudo (Perl 6)

class Test::Harness {

    sub runtests( Str $perl, @filenames ) {
        my Int $total_test = 0;
        my Int $total_pass = 0;
        my Int $total_fail = 0;
        my Int $total_file = 0;
        my Int $time_started = int time;
        my Int $max_namechars = 1;
        for @filenames -> $name {
            if $name.chars > $max_namechars { $max_namechars = $name.chars; }
        }
        for @filenames -> Str $name {
            print "$name{'.'x($max_namechars+4-$name.chars)}";
            # run a single test as a child process and collect the output
            my @results = fake_qx( "$perl $name" ).split("\n");
            # the first line must announce the number of planned tests
            if @results[0] ~~ / <digit>+ <dot> <dot> ( <digit>+ ) / {
                shift @results;
                my Int $tests_planned = int ~ $0;
                my Int $tests_passed  = 0;
                my Int $tests_failed  = 0;
                my @failures;
                my Int $test_number = 1;
                while my $result = @results.shift {
                    given $result {
                        when / ^ ok <sp> (<digit>+) / {
                            if $0 == $test_number { $tests_passed++; }
                            else {
                                $tests_failed++;
                                say "NOK $test_number/$tests_planned";
                                say $result;
                                print "$name{'.'x($max_namechars+4-$name.chars)}";
                            }
                            $test_number++;
                        }
                        when / ^ 'not ok ' (<digit>+) / {
                            $tests_failed++;
                            push @failures, $result;
                            $test_number++;
                        }
                        when / ^ '#' / {
                            say $result;
                        }
                    }
                }
                my Int $tests_done = $tests_passed + $tests_failed;
                if $tests_done != $tests_planned {
                    say " $tests_planned tests planned, $tests_done done";
                    if $tests_done < $tests_planned {
                        $tests_failed = $tests_planned - $tests_done;
                    }
                    if $tests_done > $tests_planned {
                        $tests_planned = $tests_done;
                    }
                }
                if $tests_failed == 0 { say "ok"; }
                else {
                    # say "# Looks like you failed $tests_failed out of $tests_planned";
                    for @failures { .say; }
                }
                $total_test += $tests_planned;
                $total_pass += $tests_passed;
                $total_fail += $tests_failed;
                $total_file++;
            }
            else { say "error - need plan : {@results[0]}"; }
        }
        if $total_fail == 0 { say "All tests successful"; }
        else { say "$total_fail failed, $total_pass passed"; }
        my Int $realtime = int time - $time_started;
        print "Files=$total_file, Tests=$total_test, ";
        say "$realtime wallclock secs r{%*VM<config><revision>}";
    }

    # inefficient workaround - remove when Rakudo gets a qx operator
    sub fake_qx( $command ) {
        my Str $tempfile = "/tmp/rakudo_fake_qx.tmp";
        my Str $fullcommand = "$command >$tempfile";
        run $fullcommand;
        my Str $result = slurp( $tempfile );
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
Tested OK with Parrot/Rakudo revisions 36101-36107 (as at 2009-01-28).

=head1 SEE ALSO
L<doc:prove>

=head1 AUTHOR
Martin Berends (mberends on CPAN github #perl6 and @flashmail.com).

=end pod
