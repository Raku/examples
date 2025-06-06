use v6;

=begin pod

=TITLE Let's Get Together

=AUTHOR David Romano

In this event, you need to combine the contents of several text files into
one. There are a number of things you need to do in order to succeed at this
event:

=item 1.

Find all the text files (files with a .txt file extension) in the folder
C:\Scripts. (Make sure you use C:\Scripts; if you use any other folder you
won’t receive the points for this event.)

=item 2.

Create a new file named C:\Temp\Newfile.txt. (Once again, the full path and
name for the file your script creates must match this exactly.)

=item 3.

Copy the first line – and only the first line – from each text file in
C:\Scripts into your new file.

That’s it. When your script completes you should have a new file in your
C:\Temp folder named Newfile.txt. Newfile.txt should contain the first line
– followed by a carriage-return linefeed – from each text file in
C:\Scripts.

L<http://web.archive.org/web/20081227065437/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent3.mspx>

=end pod

my $run-dir = $*PROGRAM-NAME.IO.dirname;
my @files = dir($run-dir).sort;
my $output = $*SPEC.catdir($run-dir, 'newfile.txt');
$output.IO.unlink if $output.IO.e;

# only select .txt files required for this event
for @files.grep: { .match(/test.*\.txt $$/) } {
    my $inputfh = open $_, :r;
    my $outputfh = open $output, :a;
    $outputfh.say( $($inputfh.get) ); # $(...) forces item context
    .close for $inputfh, $outputfh;
}

# vim: expandtab shiftwidth=4 ft=perl6
