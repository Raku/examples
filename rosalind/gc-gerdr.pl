use v6;

grammar FASTA {
	token TOP { ^ \n* <DNA-string>+ }
	token DNA-string { '>' (\N+) \n (<[ACGT\n]>+) }
}

my $actions = class {
	method TOP($/) {
		make $<DNA-string>>>.ast
	}

	method DNA-string($/) {
		make [~$0, 100 * +.comb(/<[GC]>/) / +.comb(/<[ACGT]>/)]
			given ~$1
	}
};

FASTA.parse($_, :$actions).ast.sort(*.[1]).[*-1] ~ '%' ==> say()
	given slurp;
