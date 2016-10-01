use v6;

=begin pod

=TITLE Simple Lisp Interpreter

=AUTHOR Andrei Osipov

Inspired by L<http://www.norvig.com/lispy.html>

=end pod

class Symbol {
    has $.name;

    method CALL-ME($x) {
        Symbol.new(name => $x);
    }

    method gist { "#<symbol:{$.name}>" }
    method Str  { $.name }
}

class Literal {
    has $.value;
    method CALL-ME($x) {
        Literal.new(value => $x)
    }

    method gist { '"' ~ $.value ~ '"' }
    method Str  {     ~ $.value       }
}

grammar Lisp::Grammar  {
    rule TOP {
       ^^ <statement>+ $$
    }

    rule statement {
        [ <sexp> |  <atom> ]
    }

    proto token bool { * }
    token bool:sym<true>    {  '#t'  }
    token bool:sym<false>   {  '#f'  }

    proto token number { * }
    token number:sym<integer> { <[-+]>?   \d+            }
    token number:sym<float>   { <[-+]>? [ \d+ ]? '.' \d+ }

    # TODO more number types

    proto token atom { * }

    token atom:sym<bool>   { <bool>   }
    token atom:sym<number> { <number> }
    token atom:sym<string> { <string> }
    token atom:sym<quote>  { <quote>  }
    token atom:sym<symbol> { <symbol> }

    token quote {
        \c[APOSTROPHE] <statement>
    }
    token symbol {
        <-[\c[APOSTROPHE]()\s]>+
    }
    rule sexp {
        '('  ~ ')' <statement>*
    }
    token string {
        \c[QUOTATION MARK] ~ \c[QUOTATION MARK]
        [ <str> | \\ <str=.str_escape> ]*
    }
    token str {
        <-[\c[QUOTATION MARK]\\\t\n]>+
    }

    token str_escape {
        <[\c[QUOTATION MARK]\\/bfnrt]>
    }
}

class List::Actons {
    method TOP($/) {
        make $<statement>».made
    }

    method statement($/) {
        make $/.caps».values.flat».made[0]
    }

    method bool:sym<true>($/)  { make Symbol(~$/) }
    method bool:sym<false>($/) { make Symbol(~$/) }

    method number:sym<integer>($/) { make $/.Int }
    method number:sym<float>($/) { make $/.Rat }

    method atom:sym<bool>($/)   { make $<bool>.made   }
    method atom:sym<number>($/) { make $<number>.made }
    method atom:sym<string>($/) { make $<string>.made }
    method atom:sym<quote>($/)  { make $<quote>.made  }
    method atom:sym<symbol>($/) { make Symbol($<symbol>.made) }

    method atom($/) {
        make $/.caps».values.flat».made[0];
    }
    method quote($/) {
        make [ Symbol('quote'), $<statement>.made.Array ];
    }

    method symbol($/) {  make ~$/ }

    method sexp($/)    {
        make $/.caps».values.flat».made.Array;
    }

    method string($/) {
        my $str =  +@$<str> == 1
        ?? $<str>[0].made
        !! $<str>».made.join ;

        make Literal($str);
    }

    method str($/) { make $/.Str }

    method str_escape($/) { make $/.Str }
}


sub parse-sexp(Str $str) {
    state $a = List::Actons.new();
    my $parse = Lisp::Grammar.parse($str,  :actions($a));

    return fail "syntax error" unless $parse;

    return $parse.ast[0];
}


class Func {
    has Callable $.code;
    has Str      $.desc;
    method eval(@a) { $.code.(|@a)   }
    method gist     { "#<{$.desc}>" }
}

class Env {
    has       %.scope is rw;
    has  Env  $.outer;

    method resolve($key) is rw {

        if %.scope{$key}:exists {
             %.scope{$key}
        }
        else {
            fail "unbound symbol '$key'" unless $.outer;
             $.outer.resolve($key);
        }
    }
    method merge(*@env) {
        %.scope = %.scope, %(@env)
    }
    multi method evaluate-tokens(Int $x) {
        $x
    }
    multi method evaluate-tokens(Rat $x) {
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
                fail "syntax error" if +@x > 1;
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
            when 'eval' {
                my ($quoted-sexp) = @x;
                self.evaluate-tokens($quoted-sexp[1]);
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
                fail "syntax error" unless +@x;
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
                fail "$verb is not a function" unless $func ~~ Func;
                $func.eval(@args)
            }

        }

    }
    multi method evaluate-tokens(Literal $x) {
        $x
    }
    multi method evaluate-tokens(Any $x) {
        fail $x.^name ~ " is NYI"
    }
    multi method add-builtin(*@x, *%x) {
        for |@x,|%x -> $p {
            $.scope{$p.key} = Func.new:
                            code => $p.value,
                            desc => "builtin:{$p.key}"
        }
    }
    method add-constant(*@x, *%x) {
        for |@x,|%x -> $p {
            $.scope{$p.key} = $p.value
        }
    }
}

our %*LISP-GLOBAL;

our $*LISP-ENV = Env.new(scope => %*LISP-GLOBAL);


$*LISP-ENV.add-constant:
    '#t' => True,
    '#f' => False
;

$*LISP-ENV.add-builtin:
     '>'       =>-> *@a { [>] @a },
     '<'       =>-> *@a { [<] @a },
     '>='      =>-> *@a { [>=] @a },
     '<='      =>-> *@a { [<=] @a },
     '='       =>-> *@a { [==] @a },
;

# ariphmetic ops
$*LISP-ENV.add-builtin:
     '+'       =>-> *@a { [+] @a },
     '-'       =>-> *@a { +@a > 1 ?? [-] @a !! - @a[0] },
     '*'       =>-> *@a { [*] @a },
     '/'       =>-> *@a { [/] @a },
     abs       =>   &abs,
;

# lisp ops
$*LISP-ENV.add-builtin:
     list    =>-> *@a { @a.item  },
     length  =>->  $a { $a.elems  },
     cons    =>-> *@a { @a.item   },
     car     =>->  @a { @a[0]     },
     cdr     =>->  @a { @a[1...*] },
     append  =>-> *@a {
         my @x =  @a[0][0..*];
         @x.push: @a[1];
         @x;
     },
     'list?'   =>-> *@a  { so @a[0] ~~ Positional },
     'null?'   =>-> *@a  { fail "too many arguments" unless +@a == 1 ;  @a[0].elems == 0 },
;

$*LISP-ENV.add-builtin:
  not     => -> $a { not $a },
  so      => -> $a { so  $a },
  'equal?'  => -> *@a { [~~] @a },
  'symbol?' => -> *@a {
    fail "NYI"
  },
  display => -> *@a {
    say join ', ', @a.map(*.Str);
  },
  exit    => -> $a { exit $a };


sub eval(Str $sexp) {
    $*LISP-ENV.evaluate-tokens(parse-sexp $sexp)
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

multi lispify(Positional $x) {
    '\'(' ~ @$x.map(*.&lispify).join(' ') ~ ')'
}
multi lispify(Bool $x where so * )  { '#t' }
multi lispify(Bool $x where not so * )  { '#f' }
multi lispify(Any $x) { $x.gist }

sub REPL {
    my Str $exp = '';
    my Int $balance = 0;
    loop {
        try {
            my $p =  prompt(
                $exp eq ''
                    ?? '> '
                    !! ('--' xx $balance) ~ '> '
            );
            exit unless defined $p;
            $exp ~= "$p ";
            $exp ~~ s:i/ ';' ** 1..* .*? $$//;
            $balance = balanced $exp;
            fail "unexpected bracket" if $balance < 0;
            next if $balance != 0 || $exp !~~ /\S+/;

            my $result = eval $exp;

            say ";; " ~ $result.&lispify;

            CATCH {
                default {
                    say "error: $_";
                }
            }
        }
        $exp = '';
    }
}

sub MAIN(Bool :$test     = False,
         Bool :$debug    = False,
         Str  :$file            ,
         Str  :$command         ,
         ) {
    if $command {
        return eval $command
    }

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

    return TEST  if $test;
    return DEBUG if $debug;

    REPL
}

sub DEBUG {
    ...
}

sub TEST {
    use Test;

    ok so parse-sexp("1"), "number";

    ok so parse-sexp("#t"), "true";
    ok so parse-sexp("#f"), "false";
    ok so parse-sexp("(- 1 2 3)"), "simple s-exp";
    ok so parse-sexp("(+ 1 2 3 (* 1 2 3))"), "nested s-exps";

    is-deeply parse-sexp('1'), 1, "parse atom (numeric)";

    is-deeply parse-sexp('#f'), Symbol('#f'),  "parse atom (boolean)";
    is-deeply parse-sexp('var'), Symbol('var'),  "parse atom (variable)";

    ok parse-sexp("(1 2 3 4 5)") == ["1", "2","3","4","5"], "sexp";
    ok parse-sexp("(1 2 3 (4 5 6))")  == ["1", "2", "3", ["4", "5", "6"]], "nested sexps";

    {
        my $y =  [Symbol('+'), 1, 2, 3];
        is-deeply parse-sexp('(+ 1 2 3)'), $y , "s-exp";
        is-deeply parse-sexp('   (+    1   2    3 )'), $y, "spaces are irrelevant";
    }

    {
        my $y = [Symbol('foo'), 1, [Symbol('quote'), [1, 2, 3]]];
        is-deeply parse-sexp("(foo 1 '(1 2 3))"),
        $y,
        "quote by symbol";
        is-deeply parse-sexp("(foo 1 (quote (1 2 3)))"), $y, "quote by word";
    }
    #

    ok !eval("(not #t)"), "booleans";
    ok eval("(not #f)") , "booleans";
    ok !eval("(so #f)") , "booleans";
    ok  eval("(so #t)") , "booleans";

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
    ok eval("(null? '())") , 'null? on `() ';
    ok !eval("(null? '(1 2 3))") , 'null?';
    ok eval("(equal? 1 1)") ,"equal?";
    ok !eval("(equal? 1 0)") ,"equal?";

    {
        ok eval("(define xxx 1)") == 1 ,"define";
         eval("(set! xxx 2)");
        ok eval("xxx") == 2, 'set!';
    }

    ok eval("(define xs (list 1 2 3 4))") == [[1,2,3,4]] ,"define";
    ok eval("(define sqr (lambda (x) (* x x)))") , 'define'; ;
    is eval("(length xs)"), 4, 'length';
    is eval("((lambda (x) (* x x)) 13)"), 169, 'lambda';
    is eval("(sqr 10)"), 100, 'lambda';
    ok eval("(define plus (lambda (x y) (+ x y)))") && eval("(plus 1 2)") == 3, "lambda";
    ok eval("(if (> 1 2) 3 4)") == 4, 'if';
    ok eval("(if (< 1 2) 3 4)") == 3, 'if';
    ok eval("(abs 3)") == 3, 'abs';
    ok eval("(abs (- 3))") == 3, 'abs';

    ok eval("(begin 1 2 3 4 5)") == 5, 'begin';
    ok eval("(quote (1 2 3 4 5))") == [<1 2 3 4 5>], 'quote';
    ok eval("(quote (1))") == ['1',], 'quote';

    ok eval("(eval (quote 1))") == 1 , 'eval';
    ok eval("(eval '(+ 1 2 3))") == 6 , 'eval';
    ok (
        eval "(list 1 (list 2 (list 3 (list 3 5))))" ) ==
                [["1", ["2", ["3", ["3", "5"]]]]], 'nested list';
    ok eval(qq{ (define fib (lambda (n)  (if (< n 2)  1  (+ (fib (- n 1)) (fib (- n 2)))))) })  &&
    eval("(fib 10)") == 89, 'fib(10)';
    eval '
         (define (sqrt x)
           (begin
            (define (square x) (* x x))
            (define (average x y) (/ (+ x y) 2))
            (define (good-enough? guess x)
              (< (abs (- (square guess) x)) 0.001))
            (define (improve guess)
              (average guess (/ x guess)))
            (define (sqrt-iter guess)
              (if (good-enough? guess)
                  guess
                (sqrt-iter (improve guess))))
            (sqrt-iter 1.0)))
    ';
    ok eval("(sqrt 4)").Int == 2, 'sqrt example';

    done-testing;
}

# vim: expandtab shiftwidth=4 ft=perl6
