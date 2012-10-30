use v6;

<A C G T>.map({ +.comb(/$^symbol/) }).say given slurp;
