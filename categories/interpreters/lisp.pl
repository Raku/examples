use v6;

=begin pod

=TITLE Simple Lisp Interpreter

=AUTHOR Andrei Osipov

Inspired by L<http://www.norvig.com/lispy.html>

=end pod

subset Number of Str where  -> $x {
    so $x ~~ /^^ <[-+]>?\d+ ( '.' \d* )? $$/
}

class Func {
    has Callable $.code;
    has Str      $.desc;
    method eval(@a) { $.code.(|@a)   }
    method gist     { "#<{$.desc}>" }
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
    method resolve($key) is rw {
        if %.scope{$key}:exists {
            %.scope{$key}
        }
        else {
            fail "Not found symbol '$key'" unless $.outer;
            $.outer.resolve($key)
        }
    }
    method merge(*@env) {
        %.scope = %.scope, %(@env)
    }
    multi method evaluate-tokens(Number $x) {
        $x
    }
    multi method evaluate-tokens(Symbol $x) {
        self.resolve($x)
    }
    multi method evaluate-tokens(Positional $x) {
        my @x = @($x);
        fail "Syntax error" if +@x == 0;
        my $verb = @x.shift;
        given $verb {
            when 'quote'   {
                @x[0];
            }
            when 'if'      {
                my ($test,
                $conseq,
                $alt) = @x;
                self.evaluate-tokens(
                    self.evaluate-tokens($test)
                    ?? $conseq
                    !! $alt
                )
            }
            when 'set!'    {
                my ($var, $exp) = @x;
                self.resolve($var) = self.evaluate-tokens($exp);
                #return $var;

            }
            when 'define'  {
                my ($var, $exp) = @x;
                if $var ~~ Positional {
                    $.scope{$var[0]} =
                    self.evaluate-tokens([ Symbol('λ'), [ $var[1..*] ], $exp]);
                }
                else { $.scope{$var}  =self.evaluate-tokens($exp); }
            }
            when 'lambda' | 'λ' {
                my ($vars, $exp) = @x;
                Func.new( code => -> *@argv {
                    my %x = flat ($vars.list Z @argv);
                    my $new-env = Env.new(scope => %x , outer => self);
                    $new-env.evaluate-tokens($exp)
                },
                desc => "closure:arity:{$vars.elems}" );

            }
            when 'begin'   {
                my $val;
                for @x -> $exp {
                    $val = self.evaluate-tokens($exp);
                }
                $val;
            }
            default {
                my $func = self.evaluate-tokens($verb);
                my @args = map {
                    self.evaluate-tokens($^x)
                }, @x;
                fail "$verb is not a function" unless
                $func ~~ Func;
                $func.eval(@args)


            }

        }

    }
}

our %*BUILTINS    =
'+'          => -> *@a { [+] @a },
'-'          => -> *@a { +@a > 1 ?? [-] @a !! - @a[0] },
'*'          => -> *@a { [*] @a },
'/'          => -> *@a { [/] @a },
'abs'        => -> $a { abs $a },
'not'        => -> $a { not $a } ,
'so'         => -> $a { so  $a } ,
'>'          => -> *@a { [>] @a },
'<'          => -> *@a { [<] @a },
'>='         => -> *@a { [>=]  @a },
'<='         => -> *@a { [<=]  @a },
'='          => -> *@a { [==]  @a },
'equal?'     => -> *@a { [~~]  @a },
'length' => -> $a {
        $a.elems
},
'cons'   => -> *@a { @a.item },
'car'    => ->  @a {  @a[0] },
'cdr'    => ->  @a {
        @a[1...*]
},
'append' => -> *@a {
        my @x =  @a[0][0..*];
        @x.push: @a[1];
        @x;
},
'list'   => -> *@a { @a.item  },
'list?'  => ->  $a  { so $a ~~ Positional },
'null?'  => -> Positional $a  {
        $a.elems == 0
},
'symbol?' => -> *@a {
        #so @a ~~ Str
},
'display' => -> *@a {
        say join ', ', @a.map(*.Str);
},
'exit'    => -> $a { exit $a }
;

our %*LISP-GLOBAL =
'#f' => False,
'#t' => True,
|map { $_.key => Func.new(code => $_.value, desc => "builtin:{$_.key}") }, %*BUILTINS;

our $*LISP-ENV = Env.new(scope => %*LISP-GLOBAL);

sub tokenize(Str $s) {
    my @tokens = $s.trans(<()> => [' ( ', ' ) ' ])\
        .split(/\s+/, :g)\
            .grep(*.chars);
    return @tokens.Array;
}

multi read-from-tokens([]) {
    fail  "unexpected EOF while reading"
}

multi read-from-tokens(@tokens) {
    my $token = @tokens.shift;
    given $token {
        when '(' {
            fail "unexpected EOF while reading" unless @tokens;
            my @x = gather while @tokens[0] ne ')' {
                take read-from-tokens(@tokens)
            }
            @tokens.shift;
            return @x.item;
        }
        when ')' { fail "unexpected ')'" }
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

sub balanced($s) {
    my $l = 0;
    for $s.comb {
        when ")" {
            --$l;
            #return False if $l < 0;
        }
        when "(" {
            ++$l;
        }
    }
    $l ;
}

sub repl {
    my Str $exp = '';
    my Int $balance = 0;
    loop {
        try {
            exit unless defined my $p =  prompt($exp eq '' ?? "> " !! ("--" xx $balance) ~ "> ");
            $exp ~= "$p ";
            $exp ~~ s:i/ ';' ** 1..* .*? $$//;
            $balance = balanced $exp;
            fail "unexpected bracket" if $balance < 0;
            next if $balance != 0 || $exp !~~ /\S+/;

            my $result = eval $exp;
            say ";; " ~ $result.&to-string;
            CATCH {
                default {
                    say "error: $_";
                }
            }
        }
        $exp = '';
    }
}

multi to-string(Number $exp) {
    $exp
}
multi to-string(Func $exp) {
    $exp.gist;
}
multi to-string(Positional $exp) {
    "(" ~ join ' ', $exp[0].map(*.&to-string) ~ ")"
}
multi to-string(Symbol $exp) { $exp }

multi to-string(Bool $x ) { $x ?? "#t" !! "#f" }
multi to-string(Any $x) { $x.perl }

sub MAIN(Bool :$run-tests = False,
         Str  :$file) {
    if $file {
        die "Can't open '$file'" unless $file.IO.f;
        my $exp;
        for $file.IO.lines {
            my $line = $_;
            $line ~~ s:i/ ';' * 1..*  .*? $$ //;
            $exp ~= $line;
            if balanced($exp) == 0 {
                eval $exp;
                $exp = '';
            }
        }
        return;
    }
    if $run-tests {
        return tests;
    }
    repl;
}


sub tests {

    use Test;

    ok tokenize("(1 2 3 4 5)") == ["(", "1", "2", "3", "4", "5", ")"], "tokenize";
    ok read("(1 2 3 4 5)") == ["1", "2","3","4","5"], "read";
    ok read("(1 2 3 (4 5 6))")  == ["1", "2", "3", ["4", "5", "6"]], "read";

    ok eval("(not #t)") == False, "booleans";
    ok eval("(not #f)") == True, "booleans";
    ok eval("(+ 1 2 3)") == 6, 'sum';
    ok eval("(* 1 2 5)") == 10, 'product';
    ok eval("(cons 1 2)") == ['1','2'], 'cons';
    ok eval("(append (cons 1 2) 1)") == [<1 2 1>], 'append';
    ok eval("(list 1 2 3 4)") == [1,2,3,4], "list";
    ok eval("(car (list 1 2 3 4))") == 1 ,"car";
    ok eval("(cdr (list 1 2 3 4))") == [2,3,4] ,"cdr";
    ok eval("(list? (list 1 2 3 4))") ,"list?";
    ok !eval("(list? #f)") ,"list?";
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
    ok eval("((lambda (x) (* x x)) 13))") == 169, 'lambda';
    ok eval("(sqr 10)") == 100, 'lambda';
    ok eval("(define plus (lambda (x y) (+ x y)))") &&
    eval("(plus 1 2)") == 3, "lambda";
    is eval("(length xs)"), 4, 'length';
    ok eval("(if (> 1 2) 3 4)") == 4, 'if';
    ok eval("(if (< 1 2) 3 4)") == 3, 'if';
    ok eval("(abs (- 3))") == 3, 'abs';
    ok eval("(begin 1 2 3 4 5)") == 5, 'begin';
    ok eval("(quote (1 2 3 4 5))") == [<1 2 3 4 5>], 'quote';
    ok eval("(quote (1))") == ['1',], 'quote';
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

    done-testing;
}

# vim: expandtab shiftwidth=4 ft=perl6
