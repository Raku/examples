use v6;

=begin pod

=TITLE Coffee Break

=AUTHOR Eric Hodges

It's Monday morning, at least half the people in the building had to work
through the weekend, everyone's a little tired and there's still a ton of
work to do. So the kindly group assistant has decided to go get everyone
coffee. Each person can choose between a Latte, an Espresso, and a
Cappuccino. The assistant wanders from one office to the next taking orders.
(There are several people in each office.) He writes down the office number,
then the number of Lattes, Espressos, and cappuccinos for each. His list
looks like this:

    Office 100
    Espresso 3
    Latte 1
    Cappuccino 1
    Office 200
    Cappucino 2
    Latte 2
    Espresso 1
    Office 300
    …

And so on. As soon as he's done, however, he realizes he has one problem: he
doesn't want to place an order for 3 espressos and 1 espresso and 2
espressos, etc. He needs to place an order for the total number of each type
of drink. You'll successfully complete this event if you read from the text
file containing the order (Coffee.txt in the Scripting Games 2008
Competitor's Pack) and correctly output a tally of the number of each type
of drink the assistant needs to order, something like this:

    Espresso: 15
    Latte: 10
    Cappuccino: 14

Make sure that you put the file Coffee.txt in the C:\Scripts folder. If you
reference any path other than C:\Scripts\Coffee.txt your script will
probably fail when we test it.

L<http://web.archive.org/web/20081210123558/http://www.microsoft.com/technet/scriptcenter/funzone/games/games08/bevent6.mspx>

=end pod

my $coffee-list = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'coffee.txt');
my $lines = slurp($coffee-list).chomp;
my %order;
for $lines.split(/\n/) {
    my ($drink, $amount) = $_.split(' ');
    next if $drink eq 'Office';
    %order{$drink} += $amount;
}

for %order.kv -> $drink, $qty {
    "{$drink}: {$qty}".say;
}

# vim: expandtab shiftwidth=4 ft=perl6
