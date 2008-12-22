use v6;

my @urls = ('http://www.something.com/blah.aspx?code=',
            'http://www.somethingelse.com/stuff.aspx?thing=');

my @ids = ('375035304','564564774','346464646');

my @combined = (@urls X @ids).map: {$^a ~ $^b};

.say for @combined;
