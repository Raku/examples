use v6;

multi combs(@, 0) { "" };
multi combs { combs(@^dict, $^n - 1) X~ @dict };
 
(.say for combs(<a b c>, $_)) for 1..4;
