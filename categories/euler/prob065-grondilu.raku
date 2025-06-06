say (^100)
.map({ $_ == 0 ?? 2 !! $_ % 3 == 2 ?? 2*($_ div 3 + 1) !! 1 })
.reverse
.reduce( 1.FatRat / * + * )
.numerator
.comb
.sum;
