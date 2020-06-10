say (1..10_000)
.map(* **3)
.classify(*.comb.sort.join)
.grep(*.value == 5)
.map(*.value.min)
.min;


