use v6;

# Specification:
#    From http://www.perlmonks.org/?node_id=731808
#    Given a list of URL prefixes, and a list of product IDs, make a list
#    consisting of each URL prefix concatenated with each product ID.


my @urls = ('http://www.something.com/blah.aspx?code=',
            'http://www.somethingelse.com/stuff.aspx?thing=');

my @ids = <375035304 564564774 346464646>;


# 1. Cross then map
# We use the cross operator X to make every combination of pairs from @urls
# and @ids. We then use map to stringify each pair. $^a is a "placeholder
# argument" - in this case, it refers to the only argument to the block.
my @combined = (@urls X @ids).map: { ~$^a };

.say for @combined;


# 2. cross hyperoperator
# We use the cross hyperoperator X~
# This combines each element from list1 with each element from list2 using ~
#    You can use any infix operator.
#    Try (1,2,3) X* (1,2,3) to generate a multiplication table.


.say for @urls X~ @ids;
