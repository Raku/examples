use v6;

constant N = 100;
say +(2..N X=> 2..N).classify({ .key ** .value });
