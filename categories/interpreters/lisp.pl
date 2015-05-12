use v6;

subset Number of Any where -> $x {
    so $x ~~ / <[0..9.]>+ /
}


class Func {
    has Callable $.code;
    has Str      $.desc;
    method eval(@a) {
	$.code.(|@a);
    }
    method Str { "#<{$.desc}>" }
}

class Symbol {
    has $.name;
    method CALL-ME($x) {
	Symbol.new(name => $x);
    }
    method Str  { $.name }
}


class Env {
    has       %.scope;
    has  Env  $.outer;
    method find($key) is rw {
	if %.scope{$key}:exists {
	    %.scope{$key}
	}
	else {
	    die "Not found symbol '$key'" unless $.outer;
	    $.outer.find($key)
	}
    }
    method merge(*@env) {
	%.scope = %.scope, %(@env)
    }
    method evaluate-tokens($x) {
	given $x {
	    when Symbol {
		self.find($x)
	    }
	    when Positional {
		given $x[0] {
		    when 'quote'   {
			my $exp = $x[1];
			$exp;
		    }
		    when 'if'      {
			my ($test,
			    $conseq,
			    $alt) = $x[1,2,3];
			self.evaluate-tokens(
			    self.evaluate-tokens($test)
			    ?? $conseq
			    !! $alt
			)
			
		    }
		    when 'set!'    {
			my ($var, $exp) = $x[1,2];
			self.find($var) = self.evaluate-tokens($exp);
			#return $var;
			
		    }
		    when 'define'  {
			my ($var, $exp) = $x[1,2];
			$.scope{$var}  =self.evaluate-tokens($exp);
		    }
		    when 'lambda'  {
			my ($vars, $exp) = $x[1...*];
			Func.new( code => -> *@argv {
					my %x = ($vars.list Z @argv);
					my $new-env = Env.new(scope => %x , outer => self);
					$new-env.evaluate-tokens($exp)
				    },
				  desc => 'lambda(@vars)' );
			
		    }
		    when 'begin'   {
			my $val;
			for @($x)[1..*] -> $exp {
			    $val = self.evaluate-tokens($exp);
			}
			$val;
		    }
		    default {
			my ($func, @list) = map { self.evaluate-tokens($^x) }, @( $x );
			if $func ~~ Func {
			    $func.eval(@list)
			}
			else {
			    $func(@list);
			    
			}
		    }
		    
		}
	    }
	    default {
		$x;
	    }
	}
    }

    
}

our %*LISP-GLOBAL =
map { $_.key => Func.new(code => $_.value, desc => "builtin:{$_.key}") }, 
('+'          => -> *@a { [+] @a },
 '-'          => -> *@a { [-] @a },
 '*'          => -> *@a { [*] @a },
 '/'          => -> *@a { [/] @a },
 'abs'        => -> *@a {   @a[0].abs     },
 'not'        => -> *@a { not @a },
 '>'          => -> *@a { [>] @a },
 '<'          => -> *@a { [<] @a },
				  '>='         => -> *@a { [>=]  @a },
				  '<='         => -> *@a { [<=]  @a },
				  '='          => -> *@a { [==]  @a },
				  'equal?'     => -> *@a { [~~]  @a },
				  'length' => -> *@a {
				      @a[0].elems
				  },
				  'cons'   => -> *@a { [ @a.item ]},
				  'car'    => -> *@a      { @a[0][0] },
				  'cdr'    => -> *@a {
				      @a[0][1..*]
				  },
				  'append' => -> *@a {
				      my @x =  @a[0][0..*];
				      @x.push:       @a[1];
				      @x;
				  },
				  'list'   => -> *@a { [ @a.item ]  },
				  'list?'  => -> *@a  { so @a[0] ~~ Positional },
				  'null?'  => -> *@a  {
				      +@a[0] == 0
				  },
				  'symbol?' => -> *@a {
				      #so @a ~~ Str
				  },
				  'display' => -> *@a {
				      say join ', ', @a.map(*.Str); 
				  }
);

 # our %*LISP-GLOBAL = map  {
 #
 # }, 
 # '+'          => -> *@a { [+] @a },
 # '-'          => -> *@a { [-] @a },
 # '*'          => -> *@a { [*] @a },
 # '/'          => -> *@a { [/] @a },
 # 'not'        => -> *@a { not @a },
 # '>'          => -> *@a { [>] @a },
 # '<'          => -> *@a { [<] @a },
 # '>='         => -> *@a { [>=]  @a},
 # '<='         => -> *@a { [<=]  @a},
 # '='          => -> *@a { [==]  @a},
 # 'equal?'     => -> *@a { [~~]  @a}, 
 
 # 'length' => -> *@a {
 #     @a.elems
 # },
 # 'cons'   => ->  *@a {
 # 	fail unless +@a == 2;			     
 # 				     [ @a[0], @a[1] ]
 # },
 # 'car'    => ->  *@a      { @a[0] },
 # 'cdr'    => ->  *@a {
 #     @a[1..*]
 # },
 # 'append' => -> *@a {
 #      [ @a ]
 # },
 # 'list'   => -> *@a  { [ $( @a ) ]  },
 # 'list?'  => -> *@a { so @a ~~ Positional },
 # 'null?'  => -> *@a {
 #     @a ~~ Positional && +@a == 0
 # },
 # 'symbol?' => -> *@a {
 #     #so @a ~~ Str
 # },
 # 'display' => -> *@a {
 #     say "@a[]";
 # };


 our $*LISP-ENV = Env.new(scope => %*LISP-GLOBAL);

 sub tokenize(Str $s) {
     $s.trans(
	 <()> => [' ( ', ' ) ' ])\
.split(/\s+/, :g)\
.grep(*.chars);
 }


 multi read-from-tokens([]) {
     die  "unexpected EOF while reading"
 }
 multi read-from-tokens(@tokens is rw) {
     my $token = @tokens.shift;
     given $token {
	 when '(' {
	     my @x = gather while @tokens[0] ne ')' {
		 take read-from-tokens(@tokens)
	     }
	     @tokens.shift;
	     return @x.item;
	 }
	 when ')' { die "unexpected ')'" }
     }
     
     atom $token;
 }


 sub read(Str $s ) {
     read-from-tokens tokenize $s;
 }

 multi atom(Number $token) {
     $token
 }
 multi atom($token) {
     Symbol($token)
 }

 sub eval(Str $sexp) {
     $*LISP-ENV.evaluate-tokens(read($sexp))
 }


 sub repl {
     for $*IN.lines -> $line {
	 print "> ";
	 my $r = eval $line;
	 say "= " ~ $r.Str;
     }
 }


 multi to-string(Positional $exp) {
     "(" ~ (join ' ', map &to-string, @($exp)) ~ ")"
 }
 multi to-string(Symbol $exp) { $exp }




 # say "==> "~ eval("(list 1 2 3 4)").perl;
 # say "==> "~  eval("(list 1 2 (list 3 4))").perl;
 # say  "==> "~ eval("(cons 2 3 )").perl;
 # say "==>" ~ eval("(append (cons 1 2) 1)").perl;
 =tests

 use Test;

 ok tokenize("(1 2 3 4 5)") == ["(", "1", "2", "3", "4", "5", ")"], "tokenize";
 ok read("(1 2 3 4 5)") == ["1", "2","3","4","5"], "read";
 ok read("(1 2 3 (4 5 6))")  == ["1", "2", "3", ["4", "5", "6"]], "read";

 ok eval("(+ 1 2 3)") == 6, 'sum';
 ok eval("(* 1 2 5)") == 10, 'product';
 ok eval("(cons 1 2)") == [['1','2']], 'cons';
 ok eval("(append (cons 1 2) 1)") == [<1 2 1>], 'append';
 ok eval("(list 1 2 3 4)") == [[1,2,3,4]], "list";
 ok eval("(car (list 1 2 3 4))") == 1 ,"car";
 ok eval("(cdr (list 1 2 3 4))") == [2,3,4] ,"cdr";
 ok eval("(list? (list 1 2 3 4))") ,"list?";
 ok eval("(null? (list))") ,"null? on empty list";
 ok eval("(equal? 1 1)") ,"equal?";
 ok !eval("(equal? 1 0)") ,"equal?";
 #ok !eval("(symbol? 1)") ,"symbol?"; # todo
 #ok eval("(symbol? +)") ,"symbol?";  # todo
 ok eval("(define xxx 1)") == 1 ,"define";
 eval("(set! xxx 2)");
 ok eval("xxx") == 2, 'set!';
 ok eval("(define xs (list 1 2 3 4))") == [[1,2,3,4]] ,"define";
 ok eval("(define sqr (lambda (x) (* x x)))") , 'define'; ;
 ok eval("(length xs)") == 4, 'length';
 ok eval("((lambda (x) (* x x)) 13))") == 169, 'lambda'; 
 ok eval("(sqr 10)") == 100, 'lambda';
 ok eval("(define plus (lambda (x y) (+ x y)))") &&
 eval("(plus 1 2)") == 3, "lambda";
 ok eval("(if (> 1 2) 3 4)") == 4, 'if';
 ok eval("(if (< 1 2) 3 4)") == 3, 'if';
 ok eval("(begin 1 2 3 4 5)") == 5, 'begin';
 ok eval("(quote (1 2 3 4 5))") == <1 2 3 4 5>, 'quote';

 ok (eval "(list 1 (list 2 (list 3 (list 3 5))))" ) == [["1", ["2", ["3", ["3", "5"]]]]], 'nested list';



 ok eval(qq{ (define fib (lambda (n)  (if (< n 2)  1  (+ (fib (- n 1)) (fib (- n 2)))))) })  &&
 eval("(fib 10)") == 89, 'fib(10)';
 eval(qq{
	     (define sqrt
	      (lambda (x)
	       (begin
		(define square (lambda (x) (* x x)))
		(define average (lambda (x y) (/ (+ x y) 2)))
		(define good-enough?
		 (lambda (guess)
		  (< (abs (- (square guess) x)) 0.001)))
		(define improve (lambda (guess)
				 (average guess (/ x guess))))
		(define sqrt-iter (lambda (guess)
				   (if (good-enough? guess)
				    guess
				    (sqrt-iter (improve guess)))))
		(sqrt-iter 1.0)))) });
 ok eval("(sqrt 4)").Int == 2, 'sqrt example';
 done
 ;

