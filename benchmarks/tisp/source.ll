; ModuleID = 'benchmarks/tisp/source.ll'
source_filename = "benchmarks/tisp/source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%struct.Val = type { i32, %struct.anon }
%struct.anon = type { ptr, %struct.anon.0, %struct.anon.1, %struct.anon.2, %struct.anon.3, ptr }
%struct.anon.0 = type { double, double }
%struct.anon.1 = type { ptr, ptr }
%struct.anon.2 = type { ptr, ptr, ptr, ptr }
%struct.anon.3 = type { ptr, ptr }
%struct.Tsp = type { ptr, i64, ptr, ptr, ptr, ptr, ptr, ptr, ptr, i64 }
%struct.Entry = type { ptr, ptr }
%struct.Rec = type { i32, i32, ptr, ptr }
%struct.__va_list = type { ptr, ptr, ptr, i32, i32 }
%struct.sigaction = type { %union.anon, %struct.__sigset_t, i32, ptr }
%union.anon = type { ptr }
%struct.__sigset_t = type { [16 x i64] }

@.str = private unnamed_addr constant [5 x i8] c"Void\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"Nil\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"Int\00", align 1
@.str.3 = private unnamed_addr constant [4 x i8] c"Dec\00", align 1
@.str.4 = private unnamed_addr constant [6 x i8] c"Ratio\00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"Str\00", align 1
@.str.6 = private unnamed_addr constant [4 x i8] c"Sym\00", align 1
@.str.7 = private unnamed_addr constant [5 x i8] c"Prim\00", align 1
@.str.8 = private unnamed_addr constant [5 x i8] c"Form\00", align 1
@.str.9 = private unnamed_addr constant [5 x i8] c"Func\00", align 1
@.str.10 = private unnamed_addr constant [6 x i8] c"Macro\00", align 1
@.str.11 = private unnamed_addr constant [5 x i8] c"Pair\00", align 1
@.str.12 = private unnamed_addr constant [4 x i8] c"Rec\00", align 1
@.str.13 = private unnamed_addr constant [5 x i8] c"Expr\00", align 1
@.str.14 = private unnamed_addr constant [9 x i8] c"Rational\00", align 1
@.str.15 = private unnamed_addr constant [4 x i8] c"Num\00", align 1
@.str.16 = private unnamed_addr constant [8 x i8] c"Invalid\00", align 1
@.str.17 = private unnamed_addr constant [9 x i8] c"; malloc\00", align 1
@stderr = external global ptr, align 8
@.str.18 = private unnamed_addr constant [33 x i8] c"; tisp: error: division by zero\0A\00", align 1
@.str.19 = private unnamed_addr constant [5 x i8] c"this\00", align 1
@.str.20 = private unnamed_addr constant [50 x i8] c"; tisp: error: Rec: missing key symbol or string\0A\00", align 1
@.str.21 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.22 = private unnamed_addr constant [42 x i8] c"; tisp: error: did not find closing '%c'\0A\00", align 1
@tisp_read_sexpr.prefix = internal global [12 x ptr] [ptr @.str.23, ptr @.str.24, ptr @.str.25, ptr @.str.26, ptr @.str.27, ptr @.str.28, ptr @.str.29, ptr @.str.30, ptr @.str.31, ptr @.str.9, ptr @.str.32, ptr @.str.33], align 8
@.str.23 = private unnamed_addr constant [2 x i8] c"'\00", align 1
@.str.24 = private unnamed_addr constant [6 x i8] c"quote\00", align 1
@.str.25 = private unnamed_addr constant [2 x i8] c"`\00", align 1
@.str.26 = private unnamed_addr constant [11 x i8] c"quasiquote\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c",@\00", align 1
@.str.28 = private unnamed_addr constant [15 x i8] c"unquote-splice\00", align 1
@.str.29 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str.30 = private unnamed_addr constant [8 x i8] c"unquote\00", align 1
@.str.31 = private unnamed_addr constant [2 x i8] c"@\00", align 1
@.str.32 = private unnamed_addr constant [3 x i8] c"f\22\00", align 1
@.str.33 = private unnamed_addr constant [10 x i8] c"strformat\00", align 1
@.str.34 = private unnamed_addr constant [5 x i8] c"list\00", align 1
@.str.35 = private unnamed_addr constant [53 x i8] c"; tisp: error: could not read given input '%c' (%d)\0A\00", align 1
@.str.36 = private unnamed_addr constant [9 x i8] c"recmerge\00", align 1
@.str.37 = private unnamed_addr constant [4 x i8] c"map\00", align 1
@.str.38 = private unnamed_addr constant [29 x i8] c"; tisp: error: invalid UFCS\0A\00", align 1
@.str.39 = private unnamed_addr constant [3 x i8] c"\09 \00", align 1
@.str.40 = private unnamed_addr constant [5 x i8] c"anon\00", align 1
@.str.41 = private unnamed_addr constant [56 x i8] c"; tisp: error: %s: expected %d argument%s, received %d\0A\00", align 1
@.str.42 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.43 = private unnamed_addr constant [43 x i8] c"; tisp: error: could not find symbol '%s'\0A\00", align 1
@.str.44 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.45 = private unnamed_addr constant [6 x i8] c"%.15g\00", align 1
@.str.46 = private unnamed_addr constant [3 x i8] c".0\00", align 1
@.str.47 = private unnamed_addr constant [6 x i8] c"%d/%d\00", align 1
@.str.48 = private unnamed_addr constant [9 x i8] c"function\00", align 1
@.str.49 = private unnamed_addr constant [6 x i8] c"macro\00", align 1
@.str.50 = private unnamed_addr constant [2 x i8] c":\00", align 1
@.str.51 = private unnamed_addr constant [10 x i8] c"#<%s%s%s>\00", align 1
@.str.52 = private unnamed_addr constant [16 x i8] c"#<primitive:%s>\00", align 1
@.str.53 = private unnamed_addr constant [11 x i8] c"#<form:%s>\00", align 1
@.str.54 = private unnamed_addr constant [6 x i8] c" %s: \00", align 1
@.str.55 = private unnamed_addr constant [5 x i8] c" ...\00", align 1
@.str.56 = private unnamed_addr constant [3 x i8] c" }\00", align 1
@.str.57 = private unnamed_addr constant [4 x i8] c" . \00", align 1
@.str.58 = private unnamed_addr constant [39 x i8] c"; tisp: could not print value type %s\0A\00", align 1
@.str.59 = private unnamed_addr constant [5 x i8] c"True\00", align 1
@.str.60 = private unnamed_addr constant [3 x i8] c"bt\00", align 1
@.str.61 = private unnamed_addr constant [8 x i8] c"version\00", align 1
@.str.62 = private unnamed_addr constant [4 x i8] c"0.1\00", align 1
@.str.63 = private unnamed_addr constant [4 x i8] c"car\00", align 1
@global_prim_val = dso_local global ptr null, align 8
@.str.64 = private unnamed_addr constant [4 x i8] c"cdr\00", align 1
@.str.65 = private unnamed_addr constant [5 x i8] c"cons\00", align 1
@.str.66 = private unnamed_addr constant [5 x i8] c"eval\00", align 1
@.str.67 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.68 = private unnamed_addr constant [5 x i8] c"cond\00", align 1
@.str.69 = private unnamed_addr constant [3 x i8] c"do\00", align 1
@.str.70 = private unnamed_addr constant [7 x i8] c"typeof\00", align 1
@.str.71 = private unnamed_addr constant [10 x i8] c"procprops\00", align 1
@.str.72 = private unnamed_addr constant [6 x i8] c"error\00", align 1
@.str.73 = private unnamed_addr constant [8 x i8] c"records\00", align 1
@.str.74 = private unnamed_addr constant [4 x i8] c"def\00", align 1
@.str.75 = private unnamed_addr constant [10 x i8] c"undefine!\00", align 1
@.str.76 = private unnamed_addr constant [9 x i8] c"defined?\00", align 1
@.str.77 = private unnamed_addr constant [7 x i8] c"strlen\00", align 1
@.str.78 = private unnamed_addr constant [6 x i8] c"floor\00", align 1
@.str.79 = private unnamed_addr constant [5 x i8] c"ceil\00", align 1
@.str.80 = private unnamed_addr constant [6 x i8] c"round\00", align 1
@.str.81 = private unnamed_addr constant [10 x i8] c"numerator\00", align 1
@.str.82 = private unnamed_addr constant [12 x i8] c"denominator\00", align 1
@.str.83 = private unnamed_addr constant [2 x i8] c"+\00", align 1
@.str.84 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.85 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.86 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.87 = private unnamed_addr constant [4 x i8] c"mod\00", align 1
@.str.88 = private unnamed_addr constant [2 x i8] c"^\00", align 1
@.str.89 = private unnamed_addr constant [2 x i8] c"<\00", align 1
@.str.90 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str.91 = private unnamed_addr constant [3 x i8] c"<=\00", align 1
@.str.92 = private unnamed_addr constant [3 x i8] c">=\00", align 1
@.str.93 = private unnamed_addr constant [4 x i8] c"sin\00", align 1
@.str.94 = private unnamed_addr constant [4 x i8] c"cos\00", align 1
@.str.95 = private unnamed_addr constant [4 x i8] c"tan\00", align 1
@.str.96 = private unnamed_addr constant [5 x i8] c"sinh\00", align 1
@.str.97 = private unnamed_addr constant [5 x i8] c"cosh\00", align 1
@.str.98 = private unnamed_addr constant [5 x i8] c"tanh\00", align 1
@.str.99 = private unnamed_addr constant [7 x i8] c"arcsin\00", align 1
@.str.100 = private unnamed_addr constant [7 x i8] c"arccos\00", align 1
@.str.101 = private unnamed_addr constant [7 x i8] c"arctan\00", align 1
@.str.102 = private unnamed_addr constant [8 x i8] c"arcsinh\00", align 1
@.str.103 = private unnamed_addr constant [8 x i8] c"arccosh\00", align 1
@.str.104 = private unnamed_addr constant [8 x i8] c"arctanh\00", align 1
@.str.105 = private unnamed_addr constant [4 x i8] c"exp\00", align 1
@.str.106 = private unnamed_addr constant [4 x i8] c"log\00", align 1
@.str.107 = private unnamed_addr constant [6 x i8] c"write\00", align 1
@.str.108 = private unnamed_addr constant [5 x i8] c"read\00", align 1
@.str.109 = private unnamed_addr constant [6 x i8] c"parse\00", align 1
@.str.110 = private unnamed_addr constant [5 x i8] c"load\00", align 1
@.str.111 = private unnamed_addr constant [4 x i8] c"cd!\00", align 1
@.str.112 = private unnamed_addr constant [4 x i8] c"pwd\00", align 1
@.str.113 = private unnamed_addr constant [6 x i8] c"exit!\00", align 1
@.str.114 = private unnamed_addr constant [4 x i8] c"now\00", align 1
@.str.115 = private unnamed_addr constant [5 x i8] c"time\00", align 1
@tibs = dso_local global [21449 x i8] c"(;;; core.tsp\0A(def (list . lst) \22Create list\22 lst)\0A(def quit() '~No REPL to quit from~)\0A\0A(def defmacro\0A  (Macro (args . body)\0A    \22Define named macro, with argument list and body\0A  First element of arguments is name of macro\0A  Also see: def\22\0A    (cond\0A      ((pair? args)\0A       (list 'def (car args) (list 'Macro (cdr args) . body)))\0A      (else\0A        (error 'defmacro \22expected macro name and argument List, recieved \22\0A              (typeof args))))))\0A\0A;;; CXR\0A\0A; TODO def car cdr with get syntax ?\0A(def (caar x) (car (car x)))\0A(def (cadr x) (car (cdr x)))\0A(def (cdar x) (cdr (car x)))\0A(def (cddr x) (cdr (cdr x)))\0A(def (caaar x) (car (car (car x))))\0A(def (caadr x) (car (car (cdr x))))\0A(def (cadar x) (car (cdr (car x))))\0A(def (caddr x) (car (cdr (cdr x))))\0A(def (cdaar x) (cdr (car (car x))))\0A(def (cdadr x) (cdr (car (cdr x))))\0A(def (cddar x) (cdr (cdr (car x))))\0A(def (cdddr x) (cdr (cdr (cdr x))))\0A(def (caaaar x) (car (car (car (car x)))))\0A(def (caaadr x) (car (car (car (cdr x)))))\0A(def (caadar x) (car (car (cdr (car x)))))\0A(def (caaddr x) (car (car (cdr (cdr x)))))\0A(def (cadaar x) (car (cdr (car (car x)))))\0A(def (cadadr x) (car (cdr (car (cdr x)))))\0A(def (caddar x) (car (cdr (cdr (car x)))))\0A(def (cadddr x) (car (cdr (cdr (cdr x)))))\0A(def (cdaaar x) (cdr (car (car (car x)))))\0A(def (cdaadr x) (cdr (car (car (cdr x)))))\0A(def (cdadar x) (cdr (car (cdr (car x)))))\0A(def (cdaddr x) (cdr (car (cdr (cdr x)))))\0A(def (cddaar x) (cdr (cdr (car (car x)))))\0A(def (cddadr x) (cdr (cdr (car (cdr x)))))\0A(def (cdddar x) (cdr (cdr (cdr (car x)))))\0A(def (cddddr x) (cdr (cdr (cdr (cdr x)))))\0A\0A;;; Types\0A\0A(def (any? x)         True)\0A(def (void? x)        (= (typeof x) \22Void\22))\0A(def (nil? x)         (= (typeof x) \22Nil\22))\0A(def  empty?          nil?)\0A(def (integer? x)     (= (typeof x) \22Int\22)) ; TODO shorten type querry funcs ?\0A(def (decimal? x)     (= (typeof x) \22Dec\22))\0A(def (ratio? x)       (= (typeof x) \22Ratio\22))\0A(def (string? x)      (= (typeof x) \22Str\22))\0A(def (symbol? x)      (= (typeof x) \22Sym\22))\0A(def (primitive? x)   (= (typeof x) \22Prim\22))\0A(def (specialform? x) (= (typeof x) \22Form\22))\0A(def (function? x)    (= (typeof x) \22Func\22))\0A(def (macro? x)       (= (typeof x) \22Macro\22))\0A(def (record? x)      (= (typeof x) \22Rec\22))\0A(def (pair? x)        (= (typeof x) \22Pair\22))\0A(def (atom? x)        (not (pair? x)))\0A(def (cons? x)        (and (pair? x) (not (pair? (cdr x)))))\0A(def (list? x)        (if (pair? x) (list? (cdr x)) (not x)))\0A(def (boolean? x)     (or (= x True) (nil? x)))\0A(def (true? x)        (= x True))\0A(def  false?          nil?)\0A(def (builtin? x)     (or (primitive? x) (specialform? x)))\0A(def (procedure? x)   (or (builtin? x) (or (function? x) (macro? x))))\0A(def (rational? x)    (or (integer? x) (ratio? x)))\0A(def (number? x)      (or (rational? x) (decimal? x)))\0A\0A(def (Bool x) (if x True Nil))\0A; TODO handle string and sym\0A(def (Pair x)\0A  (cond\0A    ((rational? x)\0A     (cons (numerator x)\0A           (denominator x)))\0A    ((decimal? x)\0A     (cons (integer (truncate x))\0A           (- x (truncate x))))\0A    ((or (void? x) (nil? x) (pair? x)) x)\0A    (else (cons x Nil))))\0A\0A(defmacro (assert expr)\0A  `(unless ,expr\0A        (error 'assert \22assertion \22 ',expr \22 failed\22)))\0A\0A; TODO support any sized list n depending on size of optional val\0A(def (default n val)\0A  (cond\0A    ((nil? n) val)\0A    ((and (pair? n) (nil? (cdr n)))\0A     (car n))\0A    (else (error 'default \22expected only 1 optional argument\22))))\0A\0A;;; Control Flow\0A\0A; TODO if b = pair and car b = else use cdr b\0A(defmacro (if con a b)\0A  \22Execute a if condition con is true, otherwise run b\22\0A  (list 'cond (list con a) (list True b)))\0A(def else True)\0A(defmacro (when con . body)\0A  \22Execute body if condition con is true\22\0A  (list 'cond (list con (cons 'do body))))\0A(defmacro (unless con . body)\0A  \22Execute body unless condition, con, is true\22\0A  (list 'cond (list (list not con) (cons 'do body))))\0A\0A(defmacro (let vars . body)\0A  \22Execute body with new local variables in vars\0A  vars is a list of name and value pairs\22\0A  (list (list* 'Func ()\0A               (append\0A                 (map\0A                   @(list* 'def (car it) (cdr it))\0A                   vars)\0A                 body))))\0A\0A(defmacro (recur proc vars . body)\0A  \22Do recursion within body by calling proc with values for vars\0A  Also see: let\22\0A  (list 'let\0A        (list*\0A          (list proc (list* 'Func (map car vars) body))\0A          vars)\0A        (list* proc (map car vars))))\0A\0A; TODO support else that is run if no values are equal\0A(defmacro (switch val . body)\0A  \22Compare value to first element in each body statement, only running line where they are equal\22\0A  (list* 'cond (map\0A                 @`((= ,val ,(car it)) ,(cadr it))\0A                 body)))\0A\0A(defmacro (quasiquote expr)\0A  \22Recursively quote the given expression\0A  Automatically quotes each element within the expression, but evaluates the\0A  element if it is labeled with the unquote macro.\0A  Can be shortened with the ` prefix.\0A  Also see: quote, unquote, unquote-splice\22\0A  (def (check form)\0A    (unless (and (pair? (cdr form)) (nil? (cddr form)))\0A      (error (car form) \22invalid form \22 form)))\0A  (def (quasicons a d)\0A    (if (pair? d)\0A      (if (= (car d) 'quote)\0A        (if (and (pair? a) (= (car a) 'quote))\0A          (list 'quote (list* (cadr a) (cadr d)))\0A          (if (nil? (cadr d))\0A            (list 'list a)\0A            (list list* a d)))\0A        (if (member (car d) '(list list*))\0A          (list* (car d) a (cdr d))\0A          (list list* a d)))\0A      (list list* a d)))\0A  (recur f ((expr expr) (n 0))\0A    (cond\0A      ((nil? expr) Nil)\0A      ((atom? expr) (list 'quote expr))\0A      ((= (car expr) 'quasiquote)\0A       (check expr)\0A       (quasicons ''quasiquote (f (cdr expr) (+ n 1))))\0A      ((= (car expr) 'unquote)\0A       (check expr)\0A       (if (= n 0)\0A         (cadr expr)\0A         (quasicons ''unquote (f (cdr expr) (- n 1)))))\0A      ((= (car expr) 'unquote-splice)\0A       (check expr)\0A       (if (= n 0)\0A         (error 'unquote-splice \22invalid context for \22 (cadr expr))\0A         (quasicons ''unquote-splice (f (cdr expr) (- n 1)))))\0A      ((and (= n 0) (and (pair? (car expr)) (= (caar expr) 'unquote-splice)))\0A       (check (car expr))\0A       (let (d: (f (cdr expr) n))\0A         (if d\0A           (list 'append (cadar expr) d)\0A           (cadar expr))))\0A      (else (quasicons (f (car expr) n) (f (cdr expr) n))))))\0A\0A(defmacro (unquote expr)\0A  \22Unquote expression so its evaluated before placed into the quasiquote\0A  Can be shortened with the , prefix\0A  Errors if called outside quasiquote\0A  Also see: quasiquote, unquote-splice, quote\22\0A  (error 'unquote \22called outside of quasiquote\22))\0A(defmacro (unquote-splice expr)\0A  \22Unquote and splice the expression into the quasiquote\0A  If the value evaluated is a list, embedded each element into the quasiquote\0A  Can be shortened with the ,@ prefix\0A  Errors if called outside a quasiquote of a list\0A  Also see: quasiquote, unquote, quote\22\0A  (error 'unquote-splice \22called outside of quasiquote\22))\0A\0A;;; Logic\0A\0A(def False ())\0A(def (not x)\0A  (if x Nil True))\0A; Use a macro so arguments aren't evaluated all at once\0A(defmacro (and a b)\0A  \22Return b if a is not nil, else return nil\22\0A  (list 'if a b Nil))\0A(defmacro (or a b)\0A  \22Return a if not nil, else return b\22\0A  (list 'if a a b))\0A(defmacro (xor? a b)\0A  \22Exclusive or, either a or b are true, but not if both are true\22\0A  (list 'and (list 'or a b) (list 'not (list 'and a b))))\0A;;; Lists\0A\0A; TODO rename to remove *\0A(def (list* . lst)\0A  \22Create improper list, last element is not Nil\22\0A  (if (cdr lst)\0A    (cons (car lst) (apply list* (cdr lst)))\0A    (car lst)))\0A\0A(def (do0 . body)\0A  \22Evaluate each expression in body, returning first\0A  Also see: do\22\0A  (car body))\0A\0A(def (length lst)\0A  \22Number of elements in given list\22\0A  (recur f ((lst lst) (x 0))\0A    (if (pair? lst)\0A      (f (cdr lst) (+ x 1))\0A      x)))\0A\0A(def (last lst)\0A  \22Last element of list\22\0A; recur loop ((lst lst) (n (if n (car n) 0)))\0A  (if (cdr lst)\0A    (last (cdr lst))\0A    (car lst)))\0A\0A; TODO make nth generic for list str vec, made up of list-ref vec-ref str-ref\0A(def (nth lst n)\0A  \22Element number n of list, starting from 0\0A  If negative get number from end of list\22\0A  (cond\0A    ((atom? lst)\0A     (error 'nth \22index of list out of bounds\22))\0A    ((< n 0) (nth lst (+ (length lst) n)))\0A    ((= n 0) (car lst))\0A    (else (nth (cdr lst) (- n 1)))))\0A\0A; TODO diff name head/tail since conflicts w/ unix\0A; TODO support negative numers like unix tail/head to count from end backwards\0A(def (head lst n)\0A  \22First n elements of list\22\0A  (cond\0A    ((<= n 0) Nil)\0A    ((atom? lst)\0A     (error 'name \22index of list out of bounds\22))\0A    (else (cons (car lst) (head (cdr lst) (- n 1))))))\0A\0A(def (tail lst n)\0A  \22Last n elements of list\22\0A  (cond\0A    ((<= n 0) lst)\0A    ((atom? lst)\0A     (error 'tail \22index of list out of bounds\22))\0A    (else (tail (cdr lst) (- n 1)))))\0A\0A(def (count elem lst) ; TODO swap arg order?\0A  (cond ((nil? lst) 0)\0A        ((atom? lst) (error 'count \22expected proper list\22))\0A        ((= elem (car lst)) (+ 1 (count elem (cdr lst))))\0A        (else (count elem (cdr lst)))))\0A        ; (else (Binary((elem = car(lst))) + count(elem cdr(lst))))\0A\0A(def (apply proc args) ; TODO many args\0A  \22Run procedure with given arguments list\22\0A  (eval (map @(list 'quote it) ; prevent proc and args from being evaluated twice\0A             (cons proc args))))\0A\0A; TODO rename to foreach (for), swap proc and lst\0A; TODO many lsts for proc w/ multi arguments, used for index\0A; [lines 0..len(lines)] |> foreach (line num) => println(num \22: \22 line)\0A(def (map proc lst)\0A  \22Return new list created by applying procedure to each element of the input list\22\0A  (if pair?(lst)\0A    (cons (proc (car lst))\0A          (map proc (cdr lst)))\0A    Nil))\0A\0A(def (convert from to lst)\0A  \22Convert every member from of list into to\22\0A  (map @(if (= from it) to it) lst))\0A\0A; TODO assoc memp procedure equivalent\0A(def (assoc key table)\0A  \22Return first list in table where the first element matches the key\0A  If not found, return nil\22\0A  (cond ((nil? table) Nil)\0A        ((= key (caar table)) (car table))\0A        (else (assoc key (cdr table)))))\0A\0A(def (filter proc lst)\0A  \22Only keep elements of list where applying proc returns true\0A  Also see: keep, remove, member, memp\22\0A  (cond\0A    ((not (pair? lst)) Nil)\0A    ((proc (car lst)) (cons (car lst) (filter proc (cdr lst))))\0A    (else (filter proc (cdr lst)))))\0A\0A; TODO keep* remove*\0A(def (keep elem lst)\0A  \22Return list with only elements matching elem\0A  Also see: filter, remove\22\0A  (filter @(= elem it) lst))\0A\0A(def (remove elem lst)\0A  \22Return list without elements matching elem\0A  Also see: filter, keep\22\0A  (filter @(/= elem it) lst))\0A\0A(def (memp proc lst)\0A  \22Return list of elements after first time procedure applied to each is not nil\0A  Also see: member, filter\22\0A  (cond ((nil? lst) Nil)\0A        ((proc (car lst)) lst)\0A        (else (memp proc (cdr lst)))))\0A\0A(def (member elem lst)\0A  \22Return list of elements after first matching elem\0A  Also see: memp, filter\22\0A  (memp @(= elem it) lst))\0A\0A(def (everyp? proc lst)\0A  \22Return boolean if every element in list passes proc\22\0A  (if (pair? lst)\0A    (if (proc (car lst))\0A      (everyp? proc (cdr lst))\0A      False)\0A    True))\0A\0A(def (every? elem lst)\0A  \22Return boolean if every element in list is equal to elem\22\0A  (everyp? @(= elem it) lst))\0A\0A; TODO rewrite, optimize tco?\0A(def (compose . procs)\0A  \22Create function made from chaining procedures given\22\0A  (cond\0A    ((nil? procs) (Func x x))\0A    ((nil? (cdr procs)) (car procs))\0A    (else\0A      (Func x\0A        ((car procs) (apply (apply compose (cdr procs)) x))))))\0A\0A(def (reverse lst)\0A  \22Reverse order of list\22\0A  (recur f ((in lst) (out Nil))\0A    (if (pair? in)\0A      (f (cdr in) (cons (car in) out))\0A      out)))\0A\0A; TODO accept many lists to append\0A(def (append x y)\0A  \22Append list y to end of list x\22\0A  (cond\0A    ((pair? x) (cons (car x) (append (cdr x) y)))\0A    ((nil? x) y)\0A    ; (else (cons x y)) ; support appending non lists (for flatmap)\0A    (else (error 'append \22expected proper list\22))))\0A\0A; TODO zip to proper pairs (def zip' (zip args (nil list)))\0A(def (zip x y) ; TODO many args to create longer pairs\0A  \22Create list of pairs made up of elements of both lists\22\0A  (cond ((and (nil? x) (nil? y)) Nil)\0A        ((or (nil? x) (nil? y)) (error 'zip \22given lists of unequal length\22))\0A        ((and (pair? x) (pair? y))\0A         (cons (cons (car x) (car y))\0A               (zip (cdr x) (cdr y))))))\0A\0A;;; Stacks\0A\0A(def (push stack val)\0A  \22Add value to front of stack\0A  Also see: pop, peek\22\0A  (cons val stack))\0A\0A(def (pop stack)\0A  \22Get stack without first element\0A  Also see: push, peek\22\0A  (if stack\0A    (cdr stack)\0A    (error 'pop \22Improper stack: \22 stack)))\0A\0A(def (peek stack)\0A  \22Get value at front of stack\0A  Also see: push, pop\22\0A  (if (pair? stack)\0A    (car stack)\0A    (error 'peek \22Improper stack: \22 stack)))\0A\0A(def (swap stack)\0A  \22Get stack where the first 2 values are swapped\0A  Also see: push, pop, peek\22\0A  (let (x: (peek stack)\0A        y: (peek (pop stack)))\0A    (push (push (pop (pop stack)) x) y)))\0A; TODO replace w/ rec, append with def docstr-reg docstr-reg{func: \22doc string\22}\0A(def docstr-reg\0A  '((car\0A      \22car(lst)\22\0A      \22First element of list\22)\0A    (cdr\0A      \22cdr(lst)\22\0A      \22Rest of list after first element, or second element of pair\22)\0A    (cons\0A      \22cons(a d)\22\0A      \22Create new pair with a car of a and cdr of d\22)\0A    (quote\0A      \22quote(expr)\22\0A      \22'expr\22\0A      \22Return expression unevaluated\22\0A      \22  Can be shortened with the ' prefix\22\0A      \22  Also see: quasiquote, unquote, and unquote-splice\22)\0A    (eval\0A      \22eval(expr)\22\0A      \22Evaluate expression\22\0A      \22  Can be dangerous to use, as arbitrary code might be executed if the input\22\0A      \22  comes from an untrusted source\22\0A      \22  Also see: apply\22)\0A    (=\0A      \22(= . vals)\22\0A      \22Return boolean depending on if multiple values are all equal\22)\0A    (cond\0A      \22cond . (expr . body)\22\0A      \22Evaluates and returns first body with a true conditional expression\22\0A      \22  Also see: if, when, unless\22)\0A    (do\0A      \22do . body\22\0A      \22Evaluate each expression in body, returning last\22\0A      \22  Also see: do0\22)\0A    (typeof\0A      \22typeof(val)\22\0A      \22Get string stating the argument's type\22)\0A    (procprops\0A      \22procprops(prop)\22\0A      \22Get record of properties for given procedure\22\0A      \22  Includes name, args, and body for functions and macros\22\0A      \22  Only has name for builtin primitives and special forms\22)\0A    (Func\0A      \22Func args . body\22\0A      \22Func body\22\0A      \22Create anonymous function\22\0A      \22  If only body is given, create function with one argument labeled 'it'\22\0A      \22  Also see: def\22)\0A    (Macro\0A      \22Macro args . body\22\0A      \22Macro body\22\0A      \22Create anonymous macro, arguments are not evaluated before given to body\22\0A      \22  If only body is given, create macro with one argument labeled 'it'\22\0A      \22  Also see: defmacro\22)\0A    (def\0A      \22def var . val\22\0A      \22Define new variable with value\22\0A      \22  If value is not given, define a self-evaluating symbol\22\0A      \22\22\0A      \22def func(. args) . body\22\0A      \22Create new function with arguments list and body list\22)\0A    (undefine!\0A      \22undefine!(var)\22\0A      \22Remove variable from environment\22)\0A    (defined?\0A      \22defined?(var)\22\0A      \22Return boolean on if variable is defined in environment\22)\0A    (error\0A      \22error(func msg)\22\0A      \22Throw error, print message with function name given as symbol\22)\0A    (quit\0A      \22quit\22\0A      \22Exit REPL, equivalent to Ctrl-D\22)\0A    (Str\0A      \22Str(. vals)\22\0A      \22Convert all values into single string\22)\0A    (Sym\0A      \22Sym(. vals)\22\0A      \22Convert all values into single symbol\22)\0A    (strformat\0A      \22f\\\22str\\\22\22\0A      \22Perform interpolation on explicit string\22\0A      \22  Evaluate expression inside curly braces\22\0A      \22  Double curly braces are not evaluated, inserting a single one.\22\0A      \22  Equivalent to strformat(\\\22str\\\22\22)))\0A\0A; TODO print func args even if no docstr\0A(def (doc proc)\0A  \22Get documentation of procedure\22\0A  (unless (procedure? proc)\0A    (error 'doc \22documentation only exists for procedures\22))\0A  (def (lookup proc) ; TODO allow for non proc lookup by make doc macro\0A    (let (docstrs: (assoc procprops(proc)::name docstr-reg))\0A      (if docstrs\0A        (map println (cdr docstrs))\0A        (error 'doc procprops(proc)::name \22: no documentation found\22))))\0A  (if (or (function? proc) (macro? proc))\0A    (let (docstr: (car procprops(proc)::body))\0A      (unless (= procprops(proc)::name 'quit)\0A        (println procprops(proc)::name (or procprops(proc)::args \22()\22)))\0A      (if (string? docstr)\0A        (println docstr)\0A        (lookup proc)))\0A    (lookup proc))\0A  Void)\0A(def docstr-reg (append docstr-reg\0A  '((write\0A      \22write(file append? . vals)\22\0A      \22Write all values to file\22\0A      \22  File can be file path give as string or the symbols 'stdout or 'stderr\22\0A      \22  Append file if append? is true, otherwise override\22)\0A    (read\0A      \22read(. file)\22\0A      \22Return string read from file, or stdin if no file is provided\22)\0A    (parse\0A      \22parse(string)\22\0A      \22Parse Tisp object from given string\22)\0A    (load\0A      \22load(lib)\22\0A      \22Loads the library given as a string\22))))\0A\0A(def (newline . file) ; TODO space and tab functions, accept number of instead\0A  (if (or (nil? file) (nil? (cdr file)))\0A    (write (car (or file '(stdout))) file \22\\n\22)\0A    (error 'newline \22only zero or one file can be given\22)))\0A\0A(def (display . str)\0A  (map @(cond\0A          ((string? it) (print \22\\\22\22 it \22\\\22\22))\0A          ((void? it))\0A          ((true? it)   (print it)) ; don't quote True since it's self evaluating\0A          ; TODO if contains non symbol char print as explict sym syntax\0A          ((symbol? it) (print \22'\22 it))\0A          ((pair? it)   print(\22[\22)\0A                        display(car(it))\0A                        (map Func((x) print(\22 \22) display(x)) cdr(it))\0A                        print(\22]\22))\0A          ((record? it) print(\22{ \22)\0A                        (map Func((x) print(car(x) \22: \22) display(cdr(x)) print(\22 \22)) records(it))\0A                        print(\22}\22))\0A          (else         (print it)))\0A       str)\0A  Void)\0A(def (displayln . str) (apply display str) (newline))\0A(def (print . str)     (write 'stdout Nil . str))\0A(def (println . str)   (print . str) (newline))\0A(def printerr(. str)   (write 'stderr Nil . str))\0A(def printerrln(. str) (printerr . str) (newline))\0A;;; Constants\0A\0A(def pi (* 4 (arctan 1.)))\0A(def tau (* 2 pi))\0A(def e (exp 1.))\0A\0A;;; Functions\0A\0A(def (/= . x) (not (apply = x)))\0A(def (*^ x p) (* x (^ 10 p)))\0A(def (inc x) (+ x 1))\0A(def (dec x) (- x 1))\0A(def (truncate x) (* (floor (abs x)) (sgn x)))\0A(def (sqr x) (* x x))\0A(def (cube x) (* x (* x x)))\0A(def (root b p) (^ b (/ p)))\0A(def (sqrt x) (root x 2))\0A(def (cbrt x) (root x 3))\0A(def (logb b x) (/ (log x) (log b)))\0A(def (log10 x) (logb 10. x))\0A(def half(x) (/ x 2))\0A(def double(x) (* x 2))\0A\0A(def factorial(n)\0A  (recur loop (n: n  res: 1)\0A    (if (<= n 1)\0A      res\0A      (loop (- n 1) (* n res)))))\0A\0A(def gcd(x y)\0A  (if (= y 0)\0A    x\0A    gcd(y mod(x y))))\0A\0A; TODO mv to units tib\0A(def (deg x)\0A  \22Convert x radians to degrees\22\0A  (* x (/ 180. pi)))\0A(def (rad x)\0A  \22Convert x degrees to radians\22\0A  (* x (/ pi 180.)))\0A\0A;;; Trig\0A\0A(def (csc x)     (/ (sin x)))\0A(def (arccsc x)  (/ (arcsin x)))\0A(def (csch x)    (/ (sinh x)))\0A(def (arccsch x) (/ (arcsinh x)))\0A(def (sec x)     (/ (cos x)))\0A(def (arcsec x)  (/ (arccos x)))\0A(def (sech x)    (/ (cosh x)))\0A(def (arcsech x) (/ (arccosh x)))\0A(def (cot x)     (/ (tan x)))\0A(def (arccot x)  (/ (arctan x)))\0A(def (coth x)    (/ (tanh x)))\0A(def (arccoth x) (/ (arctanh x)))\0A\0A(def (abs x) (if (>= x 0) x (- x)))\0A(def (sgn x) (if (= x 0) x (/ (abs x) x)))\0A; TODO many args\0A(def (max a b) (if (> a b) a b))\0A(def (min a b) (if (< a b) a b))\0A(def clamp(n lower upper) min(max(n lower) upper))\0A\0A;;; Tests\0A\0A(def (positive? x) (> x 0))\0A(def (negative? x) (< x 0))\0A(def (zero? x) (= x 0))\0A(def (even? x) (= (mod x 2) 0))\0A(def (odd? x)  (= (mod x 2) 1))\0A\0A;;; List Functions\0A\0A(def (dot v w)\0A  (if v\0A    (+ (* (car v) (car w))\0A       (dot (cdr v) (cdr w)))\0A    0))\0A(def (norm v) (sqrt (dot v v)))\0A\0A(def (mean lst)\0A  (recur loop (lst: lst len: 0 avg: 0)\0A    (if pair?(lst)\0A      loop(cdr(lst) inc(len) (+ avg car(lst)))\0A      (/ avg len))))\0A\0A(def range(start end)\0A  (recur f (n: end res: Nil)\0A    (if (>= n start)\0A      (f dec(n) (cons n res))\0A      res)))\0A(def docstr-reg (append docstr-reg\0A  '((cd!\0A      \22cd!(dir)\22\0A      \22Change directory\22)\0A    (pwd\0A      \22pwd()\22\0A      \22String of current working directory\22)\0A    (exit!\0A      \22exit!(status)\22\0A      \22Exit program with status code of given integer\22\0A      \22  Zero for success, non-zero for failure\22)\0A    (now\0A      \22now()\22\0A      \22Number of seconds since 1970 (unix time stamp)\22)\0A    (time\0A      \22time(expr)\22\0A      \22Time in milliseconds it took to run expression\22))))\0A\0A; TODO % stack of prev res, %% = fst %\0A(def (repl)\0A  \22Read, evaluate, print, loop\0A  To exit enter quit or press CTRL-D\22\0A  (print \22> \22)\0A  (let (expr: (parse (read)))\0A    (unless (= expr 'quit)\0A      ; TODO push ans to stack of outputs\0A      (let (ans: (eval expr)) ; env{ :% %%: fst(%) }\0A        (unless (void? ans)\0A          (displayln ans))\0A        (repl)))))\0A\0A(def (repl-simple)\0A  \22Simple REPL interface, only dependencies are builtin functions, no tisp code\0A  To exit enter quit or press CTRL-D\0A  See repl for more advanced REPL with prettier printing\22\0A  (write 'stdout Nil \22> \22)\0A  ((Func (expr)\0A     (cond\0A       ((= expr 'quit))\0A       (else\0A         write('stdout Nil (eval expr) \22\\n\22)\0A         (repl-simple))))\0A  (parse (read))))\0A)\00", align 1
@.str.116 = private unnamed_addr constant [7 x i8] c"(repl)\00", align 1
@.str.117 = private unnamed_addr constant [33 x i8] c"tisp: expected command after -c\0A\00", align 1
@.str.118 = private unnamed_addr constant [39 x i8] c"tisp v%s (c) 2017-2025 Ed van Bruggen\0A\00", align 1
@.str.119 = private unnamed_addr constant [4 x i8] c"1.0\00", align 1
@.str.120 = private unnamed_addr constant [48 x i8] c"usage: tisp [-hrv] [-c COMMAND] [-] [FILE ...]\0A\00", align 1
@stdout = external global ptr, align 8
@.str.121 = private unnamed_addr constant [9 x i8] c"; calloc\00", align 1
@.str.122 = private unnamed_addr constant [5 x i8] c" \09\0A\0D\00", align 1
@.str.123 = private unnamed_addr constant [3 x i8] c" \09\00", align 1
@.str.124 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.125 = private unnamed_addr constant [61 x i8] c"; tisp: error: incorrect ratio format, no denominator found\0A\00", align 1
@.str.126 = private unnamed_addr constant [46 x i8] c"; tisp: error: reached end before closing %c\0A\00", align 1
@.str.127 = private unnamed_addr constant [14 x i8] c"_+-*/\\|=^<>.:\00", align 1
@.str.128 = private unnamed_addr constant [12 x i8] c"_!?@#$%&~*-\00", align 1
@.str.129 = private unnamed_addr constant [83 x i8] c"; tisp: error: expected symbol for argument of function definition, recieved '%s'\0A\00", align 1
@.str.130 = private unnamed_addr constant [7 x i8] c"record\00", align 1
@.str.131 = private unnamed_addr constant [49 x i8] c"; tisp: error: record: expected %s, received %s\0A\00", align 1
@.str.132 = private unnamed_addr constant [5 x i8] c"else\00", align 1
@.str.133 = private unnamed_addr constant [54 x i8] c"; tisp: error: could not find element '%s' in record\0A\00", align 1
@.str.134 = private unnamed_addr constant [59 x i8] c"; tisp: error: attempt to evaluate non procedural type %s\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local ptr @prim_func(ptr noundef %t, ptr noundef %r, ptr noundef %v) #0 {
entry:
  ret ptr undef
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @tsp_type_str(i32 noundef %t) #0 {
entry:
  switch i32 %t, label %sw.default [
    i32 1, label %sw.bb
    i32 2, label %sw.bb1
    i32 4, label %sw.bb2
    i32 8, label %sw.bb3
    i32 16, label %sw.bb4
    i32 32, label %sw.bb5
    i32 64, label %sw.bb6
    i32 128, label %sw.bb7
    i32 256, label %sw.bb8
    i32 512, label %sw.bb9
    i32 1024, label %sw.bb10
    i32 2048, label %sw.bb11
    i32 4096, label %sw.bb12
  ]

sw.bb:                                            ; preds = %entry
  br label %return

sw.bb1:                                           ; preds = %entry
  br label %return

sw.bb2:                                           ; preds = %entry
  br label %return

sw.bb3:                                           ; preds = %entry
  br label %return

sw.bb4:                                           ; preds = %entry
  br label %return

sw.bb5:                                           ; preds = %entry
  br label %return

sw.bb6:                                           ; preds = %entry
  br label %return

sw.bb7:                                           ; preds = %entry
  br label %return

sw.bb8:                                           ; preds = %entry
  br label %return

sw.bb9:                                           ; preds = %entry
  br label %return

sw.bb10:                                          ; preds = %entry
  br label %return

sw.bb11:                                          ; preds = %entry
  br label %return

sw.bb12:                                          ; preds = %entry
  br label %return

sw.default:                                       ; preds = %entry
  %cmp = icmp eq i32 %t, 2140
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %sw.default
  br label %return

if.end:                                           ; preds = %sw.default
  %cmp13 = icmp eq i32 %t, 20
  br i1 %cmp13, label %if.then14, label %if.end15

if.then14:                                        ; preds = %if.end
  br label %return

if.end15:                                         ; preds = %if.end
  %and = and i32 %t, 28
  %tobool = icmp ne i32 %and, 0
  br i1 %tobool, label %if.then16, label %if.end17

if.then16:                                        ; preds = %if.end15
  br label %return

if.end17:                                         ; preds = %if.end15
  br label %return

return:                                           ; preds = %if.end17, %if.then16, %if.then14, %if.then, %sw.bb12, %sw.bb11, %sw.bb10, %sw.bb9, %sw.bb8, %sw.bb7, %sw.bb6, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %retval.0 = phi ptr [ @.str.13, %if.then ], [ @.str.14, %if.then14 ], [ @.str.15, %if.then16 ], [ @.str.16, %if.end17 ], [ @.str.12, %sw.bb12 ], [ @.str.11, %sw.bb11 ], [ @.str.10, %sw.bb10 ], [ @.str.9, %sw.bb9 ], [ @.str.8, %sw.bb8 ], [ @.str.7, %sw.bb7 ], [ @.str.6, %sw.bb6 ], [ @.str.5, %sw.bb5 ], [ @.str.4, %sw.bb4 ], [ @.str.3, %sw.bb3 ], [ @.str.2, %sw.bb2 ], [ @.str.1, %sw.bb1 ], [ @.str, %sw.bb ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @tsp_lstlen(ptr noundef %v) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %len.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %v.addr.0 = phi ptr [ %v, %entry ], [ %1, %for.inc ]
  %t = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  %cmp = icmp eq i32 %0, 2048
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %inc = add nsw i32 %len.0, 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %v1 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  %1 = load ptr, ptr %cdr, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !17

for.end:                                          ; preds = %for.cond
  %t2 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %2 = load i32, ptr %t2, align 8, !tbaa !6
  %cmp3 = icmp eq i32 %2, 2
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %for.end
  br label %cleanup

if.end:                                           ; preds = %for.end
  %add = add nsw i32 %len.0, 1
  %sub = sub nsw i32 0, %add
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ %len.0, %if.then ], [ %sub, %if.end ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_val(i32 noundef %t) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 104) #11
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @perror(ptr noundef @.str.17) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end:                                           ; preds = %entry
  %t1 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 0
  store i32 %t, ptr %t1, align 8, !tbaa !6
  ret ptr %call
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #2

; Function Attrs: cold
declare void @perror(ptr noundef) #3

; Function Attrs: noreturn nounwind
declare void @exit(i32 noundef) #4

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_int(i32 noundef %i) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef 4)
  %conv = sitofp i32 %i to double
  %v = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %n = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 1
  %num = getelementptr inbounds %struct.anon.0, ptr %n, i32 0, i32 0
  store double %conv, ptr %num, align 8, !tbaa !20
  %v1 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %n2 = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 1
  %den = getelementptr inbounds %struct.anon.0, ptr %n2, i32 0, i32 1
  store double 1.000000e+00, ptr %den, align 8, !tbaa !21
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_dec(double noundef %d) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef 8)
  %v = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %n = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 1
  %num = getelementptr inbounds %struct.anon.0, ptr %n, i32 0, i32 0
  store double %d, ptr %num, align 8, !tbaa !20
  %v1 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %n2 = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 1
  %den = getelementptr inbounds %struct.anon.0, ptr %n2, i32 0, i32 1
  store double 1.000000e+00, ptr %den, align 8, !tbaa !21
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_rat(i32 noundef %num, i32 noundef %den) #0 {
entry:
  %num.addr = alloca i32, align 4
  %den.addr = alloca i32, align 4
  store i32 %num, ptr %num.addr, align 4, !tbaa !22
  store i32 %den, ptr %den.addr, align 4, !tbaa !22
  %0 = load i32, ptr %den.addr, align 4, !tbaa !22
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %1 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.18)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end

if.end:                                           ; preds = %do.end, %entry
  call void @frac_reduce(ptr noundef %num.addr, ptr noundef %den.addr)
  %2 = load i32, ptr %den.addr, align 4, !tbaa !22
  %cmp1 = icmp slt i32 %2, 0
  br i1 %cmp1, label %if.then2, label %if.end4

if.then2:                                         ; preds = %if.end
  %3 = load i32, ptr %den.addr, align 4, !tbaa !22
  %call3 = call i32 @abs(i32 noundef %3) #14
  store i32 %call3, ptr %den.addr, align 4, !tbaa !22
  %4 = load i32, ptr %num.addr, align 4, !tbaa !22
  %sub = sub nsw i32 0, %4
  store i32 %sub, ptr %num.addr, align 4, !tbaa !22
  br label %if.end4

if.end4:                                          ; preds = %if.then2, %if.end
  %5 = load i32, ptr %den.addr, align 4, !tbaa !22
  %cmp5 = icmp eq i32 %5, 1
  br i1 %cmp5, label %if.then6, label %if.end8

if.then6:                                         ; preds = %if.end4
  %6 = load i32, ptr %num.addr, align 4, !tbaa !22
  %call7 = call ptr @mk_int(i32 noundef %6)
  br label %cleanup

if.end8:                                          ; preds = %if.end4
  %call9 = call ptr @mk_val(i32 noundef 16)
  %7 = load i32, ptr %num.addr, align 4, !tbaa !22
  %conv = sitofp i32 %7 to double
  %v = getelementptr inbounds %struct.Val, ptr %call9, i32 0, i32 1
  %n = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 1
  %num10 = getelementptr inbounds %struct.anon.0, ptr %n, i32 0, i32 0
  store double %conv, ptr %num10, align 8, !tbaa !20
  %8 = load i32, ptr %den.addr, align 4, !tbaa !22
  %conv11 = sitofp i32 %8 to double
  %v12 = getelementptr inbounds %struct.Val, ptr %call9, i32 0, i32 1
  %n13 = getelementptr inbounds %struct.anon, ptr %v12, i32 0, i32 1
  %den14 = getelementptr inbounds %struct.anon.0, ptr %n13, i32 0, i32 1
  store double %conv11, ptr %den14, align 8, !tbaa !21
  br label %cleanup

cleanup:                                          ; preds = %if.end8, %if.then6, %do.body
  %retval.0 = phi ptr [ null, %do.body ], [ %call7, %if.then6 ], [ %call9, %if.end8 ]
  ret ptr %retval.0
}

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #5

; Function Attrs: nounwind uwtable
define internal void @frac_reduce(ptr noundef %num, ptr noundef %den) #0 {
entry:
  %0 = load i32, ptr %num, align 4, !tbaa !22
  %call = call i32 @abs(i32 noundef %0) #14
  %1 = load i32, ptr %den, align 4, !tbaa !22
  %call1 = call i32 @abs(i32 noundef %1) #14
  %rem = srem i32 %call, %call1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %b.0 = phi i32 [ %call1, %entry ], [ %c.0, %while.body ]
  %c.0 = phi i32 [ %rem, %entry ], [ %rem2, %while.body ]
  %cmp = icmp sgt i32 %c.0, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %rem2 = srem i32 %b.0, %c.0
  br label %while.cond, !llvm.loop !25

while.end:                                        ; preds = %while.cond
  %2 = load i32, ptr %num, align 4, !tbaa !22
  %div = sdiv i32 %2, %b.0
  store i32 %div, ptr %num, align 4, !tbaa !22
  %3 = load i32, ptr %den, align 4, !tbaa !22
  %div3 = sdiv i32 %3, %b.0
  store i32 %div3, ptr %den, align 4, !tbaa !22
  ret void
}

; Function Attrs: nounwind willreturn memory(none)
declare i32 @abs(i32 noundef) #6

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_str(ptr noundef %st, ptr noundef %s) #0 {
entry:
  %strs = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 6
  %0 = load ptr, ptr %strs, align 8, !tbaa !26
  %call = call ptr @rec_get(ptr noundef %0, ptr noundef %s)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %call1 = call ptr @mk_val(i32 noundef 32)
  %v = getelementptr inbounds %struct.Val, ptr %call1, i32 0, i32 1
  %s2 = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 0
  store ptr %s, ptr %s2, align 8, !tbaa !29
  %strs3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 6
  %1 = load ptr, ptr %strs3, align 8, !tbaa !26
  call void @rec_add(ptr noundef %1, ptr noundef %s, ptr noundef %call1)
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %retval.0 = phi ptr [ %call, %if.then ], [ %call1, %if.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define internal ptr @rec_get(ptr noundef %rec, ptr noundef %key) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %rec.addr.0 = phi ptr [ %rec, %entry ], [ %2, %for.inc ]
  %tobool = icmp ne ptr %rec.addr.0, null
  br i1 %tobool, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %call = call ptr @entry_get(ptr noundef %rec.addr.0, ptr noundef %key)
  %key1 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 0
  %0 = load ptr, ptr %key1, align 8, !tbaa !30
  %tobool2 = icmp ne ptr %0, null
  br i1 %tobool2, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %val = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %1 = load ptr, ptr %val, align 8, !tbaa !32
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %next = getelementptr inbounds %struct.Rec, ptr %rec.addr.0, i32 0, i32 3
  %2 = load ptr, ptr %next, align 8, !tbaa !33
  br label %for.cond, !llvm.loop !35

for.end:                                          ; preds = %for.cond
  br label %cleanup

cleanup:                                          ; preds = %for.end, %if.then
  %retval.0 = phi ptr [ %1, %if.then ], [ null, %for.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define internal void @rec_add(ptr noundef %rec, ptr noundef %key, ptr noundef %val) #0 {
entry:
  %call = call ptr @entry_get(ptr noundef %rec, ptr noundef %key)
  %val1 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  store ptr %val, ptr %val1, align 8, !tbaa !32
  %key2 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 0
  %0 = load ptr, ptr %key2, align 8, !tbaa !30
  %tobool = icmp ne ptr %0, null
  br i1 %tobool, label %if.end5, label %if.then

if.then:                                          ; preds = %entry
  %key3 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 0
  store ptr %key, ptr %key3, align 8, !tbaa !30
  %size = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 0
  %1 = load i32, ptr %size, align 8, !tbaa !36
  %inc = add nsw i32 %1, 1
  store i32 %inc, ptr %size, align 8, !tbaa !36
  %cap = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %2 = load i32, ptr %cap, align 4, !tbaa !37
  %div = sdiv i32 %2, 2
  %cmp = icmp sgt i32 %inc, %div
  br i1 %cmp, label %if.then4, label %if.end

if.then4:                                         ; preds = %if.then
  call void @rec_grow(ptr noundef %rec)
  br label %if.end

if.end:                                           ; preds = %if.then4, %if.then
  br label %if.end5

if.end5:                                          ; preds = %if.end, %entry
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_sym(ptr noundef %st, ptr noundef %s) #0 {
entry:
  %syms = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 7
  %0 = load ptr, ptr %syms, align 8, !tbaa !38
  %call = call ptr @rec_get(ptr noundef %0, ptr noundef %s)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %call1 = call ptr @mk_val(i32 noundef 64)
  %v = getelementptr inbounds %struct.Val, ptr %call1, i32 0, i32 1
  %s2 = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 0
  store ptr %s, ptr %s2, align 8, !tbaa !29
  %syms3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 7
  %1 = load ptr, ptr %syms3, align 8, !tbaa !38
  call void @rec_add(ptr noundef %1, ptr noundef %s, ptr noundef %call1)
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %retval.0 = phi ptr [ %call, %if.then ], [ %call1, %if.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_prim(i32 noundef %t, ptr noundef %pr, ptr noundef %name) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef %t)
  %v = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %pr1 = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 2
  %name2 = getelementptr inbounds %struct.anon.1, ptr %pr1, i32 0, i32 0
  store ptr %name, ptr %name2, align 8, !tbaa !39
  %v3 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %pr4 = getelementptr inbounds %struct.anon, ptr %v3, i32 0, i32 2
  %pr5 = getelementptr inbounds %struct.anon.1, ptr %pr4, i32 0, i32 1
  store ptr %pr, ptr %pr5, align 8, !tbaa !40
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_func(i32 noundef %t, ptr noundef %name, ptr noundef %args, ptr noundef %body, ptr noundef %env) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef %t)
  %v = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 3
  %name1 = getelementptr inbounds %struct.anon.2, ptr %f, i32 0, i32 0
  store ptr %name, ptr %name1, align 8, !tbaa !41
  %v2 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f3 = getelementptr inbounds %struct.anon, ptr %v2, i32 0, i32 3
  %args4 = getelementptr inbounds %struct.anon.2, ptr %f3, i32 0, i32 1
  store ptr %args, ptr %args4, align 8, !tbaa !42
  %v5 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f6 = getelementptr inbounds %struct.anon, ptr %v5, i32 0, i32 3
  %body7 = getelementptr inbounds %struct.anon.2, ptr %f6, i32 0, i32 2
  store ptr %body, ptr %body7, align 8, !tbaa !43
  %v8 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f9 = getelementptr inbounds %struct.anon, ptr %v8, i32 0, i32 3
  %env10 = getelementptr inbounds %struct.anon.2, ptr %f9, i32 0, i32 3
  store ptr %env, ptr %env10, align 8, !tbaa !44
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_rec(ptr noundef %st, ptr noundef %env, ptr noundef %assoc) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef 4096)
  %tobool = icmp ne ptr %assoc, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %v1 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %r = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 5
  store ptr %env, ptr %r, align 8, !tbaa !45
  br label %cleanup77

if.end:                                           ; preds = %entry
  %call2 = call i32 @tsp_lstlen(ptr noundef %assoc)
  %mul = mul nsw i32 2, %call2
  %cmp = icmp sgt i32 %mul, 0
  br i1 %cmp, label %if.then3, label %if.else

if.then3:                                         ; preds = %if.end
  br label %if.end4

if.else:                                          ; preds = %if.end
  %sub = sub nsw i32 0, %mul
  %add = add nsw i32 %sub, 1
  br label %if.end4

if.end4:                                          ; preds = %if.else, %if.then3
  %tmp.0 = phi i32 [ %mul, %if.then3 ], [ %add, %if.else ]
  %conv = sext i32 %tmp.0 to i64
  %call5 = call ptr @rec_new(i64 noundef %conv, ptr noundef null)
  %v6 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %r7 = getelementptr inbounds %struct.anon, ptr %v6, i32 0, i32 5
  store ptr %call5, ptr %r7, align 8, !tbaa !45
  %call9 = call ptr @rec_new(i64 noundef 4, ptr noundef %env)
  call void @rec_add(ptr noundef %call9, ptr noundef @.str.19, ptr noundef %call)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end4
  %cur.0 = phi ptr [ %assoc, %if.end4 ], [ %20, %for.inc ]
  %t = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  %cmp10 = icmp eq i32 %0, 2048
  br i1 %cmp10, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
  %v12 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v12, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %1 = load ptr, ptr %car, align 8, !tbaa !46
  %t13 = getelementptr inbounds %struct.Val, ptr %1, i32 0, i32 0
  %2 = load i32, ptr %t13, align 8, !tbaa !6
  %cmp14 = icmp eq i32 %2, 2048
  br i1 %cmp14, label %land.lhs.true, label %if.else46

land.lhs.true:                                    ; preds = %for.body
  %v16 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p17 = getelementptr inbounds %struct.anon, ptr %v16, i32 0, i32 4
  %car18 = getelementptr inbounds %struct.anon.3, ptr %p17, i32 0, i32 0
  %3 = load ptr, ptr %car18, align 8, !tbaa !46
  %v19 = getelementptr inbounds %struct.Val, ptr %3, i32 0, i32 1
  %p20 = getelementptr inbounds %struct.anon, ptr %v19, i32 0, i32 4
  %car21 = getelementptr inbounds %struct.anon.3, ptr %p20, i32 0, i32 0
  %4 = load ptr, ptr %car21, align 8, !tbaa !46
  %t22 = getelementptr inbounds %struct.Val, ptr %4, i32 0, i32 0
  %5 = load i32, ptr %t22, align 8, !tbaa !6
  %and = and i32 %5, 96
  %tobool23 = icmp ne i32 %and, 0
  br i1 %tobool23, label %if.then24, label %if.else46

if.then24:                                        ; preds = %land.lhs.true
  %v25 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p26 = getelementptr inbounds %struct.anon, ptr %v25, i32 0, i32 4
  %car27 = getelementptr inbounds %struct.anon.3, ptr %p26, i32 0, i32 0
  %6 = load ptr, ptr %car27, align 8, !tbaa !46
  %v28 = getelementptr inbounds %struct.Val, ptr %6, i32 0, i32 1
  %p29 = getelementptr inbounds %struct.anon, ptr %v28, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p29, i32 0, i32 1
  %7 = load ptr, ptr %cdr, align 8, !tbaa !16
  %v30 = getelementptr inbounds %struct.Val, ptr %7, i32 0, i32 1
  %p31 = getelementptr inbounds %struct.anon, ptr %v30, i32 0, i32 4
  %car32 = getelementptr inbounds %struct.anon.3, ptr %p31, i32 0, i32 0
  %8 = load ptr, ptr %car32, align 8, !tbaa !46
  %call33 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %call9, ptr noundef %8)
  %tobool34 = icmp ne ptr %call33, null
  br i1 %tobool34, label %if.end36, label %if.then35

if.then35:                                        ; preds = %if.then24
  br label %cleanup

if.end36:                                         ; preds = %if.then24
  %v37 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %r38 = getelementptr inbounds %struct.anon, ptr %v37, i32 0, i32 5
  %9 = load ptr, ptr %r38, align 8, !tbaa !45
  %v39 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p40 = getelementptr inbounds %struct.anon, ptr %v39, i32 0, i32 4
  %car41 = getelementptr inbounds %struct.anon.3, ptr %p40, i32 0, i32 0
  %10 = load ptr, ptr %car41, align 8, !tbaa !46
  %v42 = getelementptr inbounds %struct.Val, ptr %10, i32 0, i32 1
  %p43 = getelementptr inbounds %struct.anon, ptr %v42, i32 0, i32 4
  %car44 = getelementptr inbounds %struct.anon.3, ptr %p43, i32 0, i32 0
  %11 = load ptr, ptr %car44, align 8, !tbaa !46
  %v45 = getelementptr inbounds %struct.Val, ptr %11, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v45, i32 0, i32 0
  %12 = load ptr, ptr %s, align 8, !tbaa !29
  call void @rec_add(ptr noundef %9, ptr noundef %12, ptr noundef %call33)
  br label %if.end71

if.else46:                                        ; preds = %land.lhs.true, %for.body
  %v47 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p48 = getelementptr inbounds %struct.anon, ptr %v47, i32 0, i32 4
  %car49 = getelementptr inbounds %struct.anon.3, ptr %p48, i32 0, i32 0
  %13 = load ptr, ptr %car49, align 8, !tbaa !46
  %t50 = getelementptr inbounds %struct.Val, ptr %13, i32 0, i32 0
  %14 = load i32, ptr %t50, align 8, !tbaa !6
  %cmp51 = icmp eq i32 %14, 64
  br i1 %cmp51, label %if.then53, label %if.else68

if.then53:                                        ; preds = %if.else46
  %v54 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p55 = getelementptr inbounds %struct.anon, ptr %v54, i32 0, i32 4
  %car56 = getelementptr inbounds %struct.anon.3, ptr %p55, i32 0, i32 0
  %15 = load ptr, ptr %car56, align 8, !tbaa !46
  %call57 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %call9, ptr noundef %15)
  %tobool58 = icmp ne ptr %call57, null
  br i1 %tobool58, label %if.end60, label %if.then59

if.then59:                                        ; preds = %if.then53
  br label %cleanup

if.end60:                                         ; preds = %if.then53
  %v61 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %r62 = getelementptr inbounds %struct.anon, ptr %v61, i32 0, i32 5
  %16 = load ptr, ptr %r62, align 8, !tbaa !45
  %v63 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p64 = getelementptr inbounds %struct.anon, ptr %v63, i32 0, i32 4
  %car65 = getelementptr inbounds %struct.anon.3, ptr %p64, i32 0, i32 0
  %17 = load ptr, ptr %car65, align 8, !tbaa !46
  %v66 = getelementptr inbounds %struct.Val, ptr %17, i32 0, i32 1
  %s67 = getelementptr inbounds %struct.anon, ptr %v66, i32 0, i32 0
  %18 = load ptr, ptr %s67, align 8, !tbaa !29
  call void @rec_add(ptr noundef %16, ptr noundef %18, ptr noundef %call57)
  br label %if.end70

if.else68:                                        ; preds = %if.else46
  br label %do.body

do.body:                                          ; preds = %if.else68
  %19 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call69 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %19, ptr noundef @.str.20)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end70

if.end70:                                         ; preds = %do.end, %if.end60
  br label %if.end71

if.end71:                                         ; preds = %if.end70, %if.end36
  br label %for.inc

for.inc:                                          ; preds = %if.end71
  %v72 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p73 = getelementptr inbounds %struct.anon, ptr %v72, i32 0, i32 4
  %cdr74 = getelementptr inbounds %struct.anon.3, ptr %p73, i32 0, i32 1
  %20 = load ptr, ptr %cdr74, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !47

cleanup:                                          ; preds = %do.body, %if.then59, %if.then35, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then35 ], [ 1, %if.then59 ], [ 1, %do.body ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %cleanup75 [
    i32 2, label %for.end
  ]

for.end:                                          ; preds = %cleanup
  br label %cleanup75

cleanup75:                                        ; preds = %for.end, %cleanup
  %retval.1 = phi ptr [ null, %cleanup ], [ %call, %for.end ]
  br label %cleanup77

cleanup77:                                        ; preds = %cleanup75, %if.then
  %retval.2 = phi ptr [ %retval.1, %cleanup75 ], [ %call, %if.then ]
  ret ptr %retval.2
}

; Function Attrs: nounwind uwtable
define internal ptr @rec_new(i64 noundef %cap, ptr noundef %next) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 24) #11
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @perror(ptr noundef @.str.17) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end:                                           ; preds = %entry
  %size = getelementptr inbounds %struct.Rec, ptr %call, i32 0, i32 0
  store i32 0, ptr %size, align 8, !tbaa !36
  %conv = trunc i64 %cap to i32
  %cap1 = getelementptr inbounds %struct.Rec, ptr %call, i32 0, i32 1
  store i32 %conv, ptr %cap1, align 4, !tbaa !37
  %call2 = call noalias ptr @calloc(i64 noundef %cap, i64 noundef 16) #15
  %items = getelementptr inbounds %struct.Rec, ptr %call, i32 0, i32 2
  store ptr %call2, ptr %items, align 8, !tbaa !48
  %tobool3 = icmp ne ptr %call2, null
  br i1 %tobool3, label %if.end5, label %if.then4

if.then4:                                         ; preds = %if.end
  call void @perror(ptr noundef @.str.121) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end5:                                          ; preds = %if.end
  %next6 = getelementptr inbounds %struct.Rec, ptr %call, i32 0, i32 3
  store ptr %next, ptr %next6, align 8, !tbaa !33
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_eval(ptr noundef %st, ptr noundef %env, ptr noundef %v) #0 {
entry:
  %t = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  switch i32 %0, label %sw.default [
    i32 64, label %sw.bb
    i32 2048, label %sw.bb5
  ]

sw.bb:                                            ; preds = %entry
  %v1 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 0
  %1 = load ptr, ptr %s, align 8, !tbaa !29
  %call = call ptr @rec_get(ptr noundef %env, ptr noundef %1)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %sw.bb
  br label %do.body

do.body:                                          ; preds = %if.then
  %2 = load ptr, ptr @stderr, align 8, !tbaa !24
  %v2 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %s3 = getelementptr inbounds %struct.anon, ptr %v2, i32 0, i32 0
  %3 = load ptr, ptr %s3, align 8, !tbaa !29
  %call4 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.43, ptr noundef %3)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end

if.end:                                           ; preds = %do.end, %sw.bb
  br label %cleanup

sw.bb5:                                           ; preds = %entry
  %v6 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v6, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %4 = load ptr, ptr %car, align 8, !tbaa !46
  %call7 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env, ptr noundef %4)
  %tobool8 = icmp ne ptr %call7, null
  br i1 %tobool8, label %if.end10, label %if.then9

if.then9:                                         ; preds = %sw.bb5
  br label %cleanup

if.end10:                                         ; preds = %sw.bb5
  %v11 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %p12 = getelementptr inbounds %struct.anon, ptr %v11, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p12, i32 0, i32 1
  %5 = load ptr, ptr %cdr, align 8, !tbaa !16
  %call13 = call ptr @eval_proc(ptr noundef %st, ptr noundef %env, ptr noundef %call7, ptr noundef %5)
  br label %cleanup

sw.default:                                       ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %sw.default, %if.end10, %if.then9, %if.end, %do.body
  %retval.0 = phi ptr [ %v, %sw.default ], [ %call13, %if.end10 ], [ null, %if.then9 ], [ %call, %if.end ], [ null, %do.body ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_pair(ptr noundef %a, ptr noundef %b) #0 {
entry:
  %call = call ptr @mk_val(i32 noundef 2048)
  %v = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  store ptr %a, ptr %car, align 8, !tbaa !46
  %v1 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %p2 = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p2, i32 0, i32 1
  store ptr %b, ptr %cdr, align 8, !tbaa !16
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @mk_list(ptr noundef %st, i32 noundef %n, ...) #0 {
entry:
  %argp = alloca %struct.__va_list, align 8
  call void @llvm.lifetime.start.p0(i64 32, ptr %argp) #16
  call void @llvm.va_start(ptr %argp)
  %gr_offs_p = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 3
  %gr_offs = load i32, ptr %gr_offs_p, align 8
  %0 = icmp sge i32 %gr_offs, 0
  br i1 %0, label %vaarg.on_stack, label %vaarg.maybe_reg

vaarg.maybe_reg:                                  ; preds = %entry
  %new_reg_offs = add i32 %gr_offs, 8
  store i32 %new_reg_offs, ptr %gr_offs_p, align 8
  %inreg = icmp sle i32 %new_reg_offs, 0
  br i1 %inreg, label %vaarg.in_reg, label %vaarg.on_stack

vaarg.in_reg:                                     ; preds = %vaarg.maybe_reg
  %reg_top_p = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 1
  %reg_top = load ptr, ptr %reg_top_p, align 8
  %1 = getelementptr inbounds i8, ptr %reg_top, i32 %gr_offs
  br label %vaarg.end

vaarg.on_stack:                                   ; preds = %vaarg.maybe_reg, %entry
  %stack_p = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 0
  %stack = load ptr, ptr %stack_p, align 8
  %new_stack = getelementptr inbounds i8, ptr %stack, i64 8
  store ptr %new_stack, ptr %stack_p, align 8
  br label %vaarg.end

vaarg.end:                                        ; preds = %vaarg.on_stack, %vaarg.in_reg
  %vaargs.addr = phi ptr [ %1, %vaarg.in_reg ], [ %stack, %vaarg.on_stack ]
  %2 = load ptr, ptr %vaargs.addr, align 8
  %nil = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %3 = load ptr, ptr %nil, align 8, !tbaa !49
  %call = call ptr @mk_pair(ptr noundef %2, ptr noundef %3)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %vaarg.end
  %n.addr.0 = phi i32 [ %n, %vaarg.end ], [ %dec, %for.inc ]
  %cur.0 = phi ptr [ %call, %vaarg.end ], [ %8, %for.inc ]
  %cmp = icmp sgt i32 %n.addr.0, 1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %gr_offs_p1 = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 3
  %gr_offs2 = load i32, ptr %gr_offs_p1, align 8
  %4 = icmp sge i32 %gr_offs2, 0
  br i1 %4, label %vaarg.on_stack9, label %vaarg.maybe_reg3

vaarg.maybe_reg3:                                 ; preds = %for.body
  %new_reg_offs4 = add i32 %gr_offs2, 8
  store i32 %new_reg_offs4, ptr %gr_offs_p1, align 8
  %inreg5 = icmp sle i32 %new_reg_offs4, 0
  br i1 %inreg5, label %vaarg.in_reg6, label %vaarg.on_stack9

vaarg.in_reg6:                                    ; preds = %vaarg.maybe_reg3
  %reg_top_p7 = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 1
  %reg_top8 = load ptr, ptr %reg_top_p7, align 8
  %5 = getelementptr inbounds i8, ptr %reg_top8, i32 %gr_offs2
  br label %vaarg.end13

vaarg.on_stack9:                                  ; preds = %vaarg.maybe_reg3, %for.body
  %stack_p10 = getelementptr inbounds %struct.__va_list, ptr %argp, i32 0, i32 0
  %stack11 = load ptr, ptr %stack_p10, align 8
  %new_stack12 = getelementptr inbounds i8, ptr %stack11, i64 8
  store ptr %new_stack12, ptr %stack_p10, align 8
  br label %vaarg.end13

vaarg.end13:                                      ; preds = %vaarg.on_stack9, %vaarg.in_reg6
  %vaargs.addr14 = phi ptr [ %5, %vaarg.in_reg6 ], [ %stack11, %vaarg.on_stack9 ]
  %6 = load ptr, ptr %vaargs.addr14, align 8
  %nil15 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %7 = load ptr, ptr %nil15, align 8, !tbaa !49
  %call16 = call ptr @mk_pair(ptr noundef %6, ptr noundef %7)
  %v = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  store ptr %call16, ptr %cdr, align 8, !tbaa !16
  br label %for.inc

for.inc:                                          ; preds = %vaarg.end13
  %dec = add nsw i32 %n.addr.0, -1
  %v17 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p18 = getelementptr inbounds %struct.anon, ptr %v17, i32 0, i32 4
  %cdr19 = getelementptr inbounds %struct.anon.3, ptr %p18, i32 0, i32 1
  %8 = load ptr, ptr %cdr19, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !50

for.end:                                          ; preds = %for.cond.cleanup
  call void @llvm.va_end(ptr %argp)
  call void @llvm.lifetime.end.p0(i64 32, ptr %argp) #16
  ret ptr %call
}

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_start(ptr) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.va_end(ptr) #7

; Function Attrs: nounwind uwtable
define dso_local ptr @read_pair(ptr noundef %st, i8 noundef %endchar) #0 {
entry:
  %nil = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %0 = load ptr, ptr %nil, align 8, !tbaa !49
  %call = call ptr @mk_pair(ptr noundef null, ptr noundef %0)
  %conv = zext i8 %endchar to i32
  %cmp = icmp ne i32 %conv, 10
  %conv1 = zext i1 %cmp to i32
  call void @skip_ws(ptr noundef %st, i32 noundef %conv1)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %pos.0 = phi ptr [ %call, %entry ], [ %11, %for.inc ]
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %1 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %2 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %2, 0
  %arrayidx = getelementptr inbounds i8, ptr %1, i64 %add
  %3 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv2 = zext i8 %3 to i32
  %tobool = icmp ne i32 %conv2, 0
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond
  %file3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %4 = load ptr, ptr %file3, align 8, !tbaa !51
  %filec4 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %5 = load i64, ptr %filec4, align 8, !tbaa !52
  %add5 = add i64 %5, 0
  %arrayidx6 = getelementptr inbounds i8, ptr %4, i64 %add5
  %6 = load i8, ptr %arrayidx6, align 1, !tbaa !53
  %conv7 = zext i8 %6 to i32
  %conv8 = zext i8 %endchar to i32
  %cmp9 = icmp ne i32 %conv7, %conv8
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond
  %7 = phi i1 [ false, %for.cond ], [ %cmp9, %land.rhs ]
  br i1 %7, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %land.end
  br label %cleanup

for.body:                                         ; preds = %land.end
  %call11 = call ptr @tisp_read(ptr noundef %st)
  %tobool12 = icmp ne ptr %call11, null
  br i1 %tobool12, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  %t = getelementptr inbounds %struct.Val, ptr %call11, i32 0, i32 0
  %8 = load i32, ptr %t, align 8, !tbaa !6
  %cmp13 = icmp eq i32 %8, 64
  br i1 %cmp13, label %land.lhs.true, label %if.end24

land.lhs.true:                                    ; preds = %if.end
  %v15 = getelementptr inbounds %struct.Val, ptr %call11, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v15, i32 0, i32 0
  %9 = load ptr, ptr %s, align 8, !tbaa !29
  %call16 = call i32 @strncmp(ptr noundef %9, ptr noundef @.str.21, i64 noundef 2) #17
  %tobool17 = icmp ne i32 %call16, 0
  br i1 %tobool17, label %if.end24, label %if.then18

if.then18:                                        ; preds = %land.lhs.true
  call void @skip_ws(ptr noundef %st, i32 noundef %conv1)
  %call19 = call ptr @tisp_read(ptr noundef %st)
  %tobool20 = icmp ne ptr %call19, null
  br i1 %tobool20, label %if.end22, label %if.then21

if.then21:                                        ; preds = %if.then18
  br label %cleanup

if.end22:                                         ; preds = %if.then18
  %v23 = getelementptr inbounds %struct.Val, ptr %pos.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v23, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  store ptr %call19, ptr %cdr, align 8, !tbaa !16
  br label %cleanup

if.end24:                                         ; preds = %land.lhs.true, %if.end
  %nil25 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %10 = load ptr, ptr %nil25, align 8, !tbaa !49
  %call26 = call ptr @mk_pair(ptr noundef %call11, ptr noundef %10)
  %v27 = getelementptr inbounds %struct.Val, ptr %pos.0, i32 0, i32 1
  %p28 = getelementptr inbounds %struct.anon, ptr %v27, i32 0, i32 4
  %cdr29 = getelementptr inbounds %struct.anon.3, ptr %p28, i32 0, i32 1
  store ptr %call26, ptr %cdr29, align 8, !tbaa !16
  call void @skip_ws(ptr noundef %st, i32 noundef %conv1)
  br label %for.inc

for.inc:                                          ; preds = %if.end24
  %v30 = getelementptr inbounds %struct.Val, ptr %pos.0, i32 0, i32 1
  %p31 = getelementptr inbounds %struct.anon, ptr %v30, i32 0, i32 4
  %cdr32 = getelementptr inbounds %struct.anon.3, ptr %p31, i32 0, i32 1
  %11 = load ptr, ptr %cdr32, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !54

cleanup:                                          ; preds = %if.end22, %if.then21, %if.then, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 2, %if.end22 ], [ 1, %if.then21 ], [ 1, %if.then ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %cleanup51 [
    i32 2, label %for.end
  ]

for.end:                                          ; preds = %cleanup
  call void @skip_ws(ptr noundef %st, i32 noundef %conv1)
  %tobool33 = icmp ne i32 %conv1, 0
  br i1 %tobool33, label %land.lhs.true34, label %if.end46

land.lhs.true34:                                  ; preds = %for.end
  %file35 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %12 = load ptr, ptr %file35, align 8, !tbaa !51
  %filec36 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %13 = load i64, ptr %filec36, align 8, !tbaa !52
  %add37 = add i64 %13, 0
  %arrayidx38 = getelementptr inbounds i8, ptr %12, i64 %add37
  %14 = load i8, ptr %arrayidx38, align 1, !tbaa !53
  %conv39 = zext i8 %14 to i32
  %conv40 = zext i8 %endchar to i32
  %cmp41 = icmp ne i32 %conv39, %conv40
  br i1 %cmp41, label %if.then43, label %if.end46

if.then43:                                        ; preds = %land.lhs.true34
  br label %do.body

do.body:                                          ; preds = %if.then43
  %15 = load ptr, ptr @stderr, align 8, !tbaa !24
  %conv44 = zext i8 %endchar to i32
  %call45 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %15, ptr noundef @.str.22, i32 noundef %conv44)
  br label %cleanup51

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end46

if.end46:                                         ; preds = %do.end, %land.lhs.true34, %for.end
  %filec47 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %16 = load i64, ptr %filec47, align 8, !tbaa !52
  %inc = add i64 %16, 1
  store i64 %inc, ptr %filec47, align 8, !tbaa !52
  %v48 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %p49 = getelementptr inbounds %struct.anon, ptr %v48, i32 0, i32 4
  %cdr50 = getelementptr inbounds %struct.anon.3, ptr %p49, i32 0, i32 1
  %17 = load ptr, ptr %cdr50, align 8, !tbaa !16
  br label %cleanup51

cleanup51:                                        ; preds = %if.end46, %do.body, %cleanup
  %retval.1 = phi ptr [ null, %cleanup ], [ null, %do.body ], [ %17, %if.end46 ]
  ret ptr %retval.1
}

; Function Attrs: nounwind uwtable
define internal void @skip_ws(ptr noundef %st, i32 noundef %skipnl) #0 {
entry:
  %tobool = icmp ne i32 %skipnl, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %s.0 = phi ptr [ @.str.122, %if.then ], [ @.str.123, %if.else ]
  br label %while.cond

while.cond:                                       ; preds = %for.end, %if.end
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  %tobool1 = icmp ne i32 %conv, 0
  br i1 %tobool1, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %file2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %3 = load ptr, ptr %file2, align 8, !tbaa !51
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %4 = load i64, ptr %filec3, align 8, !tbaa !52
  %add4 = add i64 %4, 0
  %arrayidx5 = getelementptr inbounds i8, ptr %3, i64 %add4
  %5 = load i8, ptr %arrayidx5, align 1, !tbaa !53
  %conv6 = zext i8 %5 to i32
  %call = call ptr @strchr(ptr noundef %s.0, i32 noundef %conv6) #17
  %tobool7 = icmp ne ptr %call, null
  br i1 %tobool7, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %land.rhs
  %file8 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %6 = load ptr, ptr %file8, align 8, !tbaa !51
  %filec9 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %7 = load i64, ptr %filec9, align 8, !tbaa !52
  %add10 = add i64 %7, 0
  %arrayidx11 = getelementptr inbounds i8, ptr %6, i64 %add10
  %8 = load i8, ptr %arrayidx11, align 1, !tbaa !53
  %conv12 = zext i8 %8 to i32
  %cmp = icmp eq i32 %conv12, 59
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %land.rhs
  %9 = phi i1 [ true, %land.rhs ], [ %cmp, %lor.rhs ]
  br label %land.end

land.end:                                         ; preds = %lor.end, %while.cond
  %10 = phi i1 [ false, %while.cond ], [ %9, %lor.end ]
  br i1 %10, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %file14 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %11 = load ptr, ptr %file14, align 8, !tbaa !51
  %filec15 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %12 = load i64, ptr %filec15, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %11, i64 %12
  %call16 = call i64 @strspn(ptr noundef %add.ptr, ptr noundef %s.0) #17
  %filec17 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %13 = load i64, ptr %filec17, align 8, !tbaa !52
  %add18 = add i64 %13, %call16
  store i64 %add18, ptr %filec17, align 8, !tbaa !52
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %while.body
  %file19 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %14 = load ptr, ptr %file19, align 8, !tbaa !51
  %filec20 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %15 = load i64, ptr %filec20, align 8, !tbaa !52
  %add21 = add i64 %15, 0
  %arrayidx22 = getelementptr inbounds i8, ptr %14, i64 %add21
  %16 = load i8, ptr %arrayidx22, align 1, !tbaa !53
  %conv23 = zext i8 %16 to i32
  %cmp24 = icmp eq i32 %conv23, 59
  br i1 %cmp24, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %file26 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %17 = load ptr, ptr %file26, align 8, !tbaa !51
  %filec27 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %18 = load i64, ptr %filec27, align 8, !tbaa !52
  %add.ptr28 = getelementptr inbounds i8, ptr %17, i64 %18
  %call29 = call i64 @strcspn(ptr noundef %add.ptr28, ptr noundef @.str.124) #17
  %tobool30 = icmp ne i32 %skipnl, 0
  %lnot = xor i1 %tobool30, true
  %lnot.ext = zext i1 %lnot to i32
  %conv31 = sext i32 %lnot.ext to i64
  %sub = sub i64 %call29, %conv31
  %filec32 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %19 = load i64, ptr %filec32, align 8, !tbaa !52
  %add33 = add i64 %19, %sub
  store i64 %add33, ptr %filec32, align 8, !tbaa !52
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %filec34 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %20 = load i64, ptr %filec34, align 8, !tbaa !52
  %inc = add i64 %20, 1
  store i64 %inc, ptr %filec34, align 8, !tbaa !52
  br label %for.cond, !llvm.loop !55

for.end:                                          ; preds = %for.cond
  br label %while.cond, !llvm.loop !56

while.end:                                        ; preds = %land.end
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_read(ptr noundef %st) #0 {
entry:
  %call = call ptr @tisp_read_sexpr(ptr noundef %st)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.end
  %v.0 = phi ptr [ %call, %if.end ], [ %call24, %while.body ]
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  %cmp = icmp eq i32 %conv, 40
  br i1 %cmp, label %lor.end, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %while.cond
  %file2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %3 = load ptr, ptr %file2, align 8, !tbaa !51
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %4 = load i64, ptr %filec3, align 8, !tbaa !52
  %add4 = add i64 %4, 0
  %arrayidx5 = getelementptr inbounds i8, ptr %3, i64 %add4
  %5 = load i8, ptr %arrayidx5, align 1, !tbaa !53
  %conv6 = zext i8 %5 to i32
  %cmp7 = icmp eq i32 %conv6, 58
  br i1 %cmp7, label %lor.end, label %lor.lhs.false9

lor.lhs.false9:                                   ; preds = %lor.lhs.false
  %file10 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %6 = load ptr, ptr %file10, align 8, !tbaa !51
  %filec11 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %7 = load i64, ptr %filec11, align 8, !tbaa !52
  %add12 = add i64 %7, 0
  %arrayidx13 = getelementptr inbounds i8, ptr %6, i64 %add12
  %8 = load i8, ptr %arrayidx13, align 1, !tbaa !53
  %conv14 = zext i8 %8 to i32
  %cmp15 = icmp eq i32 %conv14, 62
  br i1 %cmp15, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %lor.lhs.false9
  %file17 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %9 = load ptr, ptr %file17, align 8, !tbaa !51
  %filec18 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %10 = load i64, ptr %filec18, align 8, !tbaa !52
  %add19 = add i64 %10, 0
  %arrayidx20 = getelementptr inbounds i8, ptr %9, i64 %add19
  %11 = load i8, ptr %arrayidx20, align 1, !tbaa !53
  %conv21 = zext i8 %11 to i32
  %cmp22 = icmp eq i32 %conv21, 123
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %lor.lhs.false9, %lor.lhs.false, %while.cond
  %12 = phi i1 [ true, %lor.lhs.false9 ], [ true, %lor.lhs.false ], [ true, %while.cond ], [ %cmp22, %lor.rhs ]
  br i1 %12, label %while.body, label %while.end

while.body:                                       ; preds = %lor.end
  %call24 = call ptr @tisp_read_sugar(ptr noundef %st, ptr noundef %v.0)
  br label %while.cond, !llvm.loop !57

while.end:                                        ; preds = %lor.end
  br label %cleanup

cleanup:                                          ; preds = %while.end, %if.then
  %retval.0 = phi ptr [ %v.0, %while.end ], [ null, %if.then ]
  ret ptr %retval.0
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @strncmp(ptr noundef, ptr noundef, i64 noundef) #8

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_read_sexpr(ptr noundef %st) #0 {
entry:
  call void @skip_ws(ptr noundef %st, i32 noundef 1)
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %0, i64 %1
  %call = call i64 @strlen(ptr noundef %add.ptr) #17
  %cmp = icmp eq i64 %call, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %none = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 2
  %2 = load ptr, ptr %none, align 8, !tbaa !58
  br label %do.end

if.end:                                           ; preds = %entry
  %file1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %3 = load ptr, ptr %file1, align 8, !tbaa !51
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %4 = load i64, ptr %filec2, align 8, !tbaa !52
  %add.ptr3 = getelementptr inbounds i8, ptr %3, i64 %4
  %call4 = call i32 @isnum(ptr noundef %add.ptr3)
  %tobool = icmp ne i32 %call4, 0
  br i1 %tobool, label %if.then5, label %if.end7

if.then5:                                         ; preds = %if.end
  %call6 = call ptr @read_num(ptr noundef %st)
  br label %do.end

if.end7:                                          ; preds = %if.end
  %file8 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %5 = load ptr, ptr %file8, align 8, !tbaa !51
  %filec9 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %6 = load i64, ptr %filec9, align 8, !tbaa !52
  %add = add i64 %6, 0
  %arrayidx = getelementptr inbounds i8, ptr %5, i64 %add
  %7 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %7 to i32
  %cmp10 = icmp eq i32 %conv, 34
  br i1 %cmp10, label %if.then12, label %if.end14

if.then12:                                        ; preds = %if.end7
  %call13 = call ptr @read_str(ptr noundef %st)
  br label %do.end

if.end14:                                         ; preds = %if.end7
  %file15 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %8 = load ptr, ptr %file15, align 8, !tbaa !51
  %filec16 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %9 = load i64, ptr %filec16, align 8, !tbaa !52
  %add17 = add i64 %9, 0
  %arrayidx18 = getelementptr inbounds i8, ptr %8, i64 %add17
  %10 = load i8, ptr %arrayidx18, align 1, !tbaa !53
  %conv19 = zext i8 %10 to i32
  %cmp20 = icmp eq i32 %conv19, 126
  br i1 %cmp20, label %if.then22, label %if.end24

if.then22:                                        ; preds = %if.end14
  %call23 = call ptr @read_str(ptr noundef %st)
  br label %do.end

if.end24:                                         ; preds = %if.end14
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end24
  %i.0 = phi i32 [ 0, %if.end24 ], [ %add60, %for.inc ]
  %conv25 = sext i32 %i.0 to i64
  %cmp26 = icmp ult i64 %conv25, 12
  br i1 %cmp26, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup61

for.body:                                         ; preds = %for.cond
  %file28 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %11 = load ptr, ptr %file28, align 8, !tbaa !51
  %filec29 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %12 = load i64, ptr %filec29, align 8, !tbaa !52
  %add.ptr30 = getelementptr inbounds i8, ptr %11, i64 %12
  %idxprom = sext i32 %i.0 to i64
  %arrayidx31 = getelementptr inbounds [12 x ptr], ptr @tisp_read_sexpr.prefix, i64 0, i64 %idxprom
  %13 = load ptr, ptr %arrayidx31, align 8, !tbaa !24
  %idxprom32 = sext i32 %i.0 to i64
  %arrayidx33 = getelementptr inbounds [12 x ptr], ptr @tisp_read_sexpr.prefix, i64 0, i64 %idxprom32
  %14 = load ptr, ptr %arrayidx33, align 8, !tbaa !24
  %call34 = call i64 @strlen(ptr noundef %14) #17
  %call35 = call i32 @strncmp(ptr noundef %add.ptr30, ptr noundef %13, i64 noundef %call34) #17
  %tobool36 = icmp ne i32 %call35, 0
  br i1 %tobool36, label %if.end59, label %if.then37

if.then37:                                        ; preds = %for.body
  %idxprom38 = sext i32 %i.0 to i64
  %arrayidx39 = getelementptr inbounds [12 x ptr], ptr @tisp_read_sexpr.prefix, i64 0, i64 %idxprom38
  %15 = load ptr, ptr %arrayidx39, align 8, !tbaa !24
  %call40 = call i64 @strlen(ptr noundef %15) #17
  %idxprom41 = sext i32 %i.0 to i64
  %arrayidx42 = getelementptr inbounds [12 x ptr], ptr @tisp_read_sexpr.prefix, i64 0, i64 %idxprom41
  %16 = load ptr, ptr %arrayidx42, align 8, !tbaa !24
  %arrayidx43 = getelementptr inbounds i8, ptr %16, i64 1
  %17 = load i8, ptr %arrayidx43, align 1, !tbaa !53
  %conv44 = zext i8 %17 to i32
  %cmp45 = icmp eq i32 %conv44, 34
  %conv46 = zext i1 %cmp45 to i32
  %conv47 = sext i32 %conv46 to i64
  %sub = sub i64 %call40, %conv47
  %filec48 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %18 = load i64, ptr %filec48, align 8, !tbaa !52
  %add49 = add i64 %18, %sub
  store i64 %add49, ptr %filec48, align 8, !tbaa !52
  %call50 = call ptr @tisp_read(ptr noundef %st)
  %tobool51 = icmp ne ptr %call50, null
  br i1 %tobool51, label %if.end53, label %if.then52

if.then52:                                        ; preds = %if.then37
  br label %cleanup

if.end53:                                         ; preds = %if.then37
  %add54 = add nsw i32 %i.0, 1
  %idxprom55 = sext i32 %add54 to i64
  %arrayidx56 = getelementptr inbounds [12 x ptr], ptr @tisp_read_sexpr.prefix, i64 0, i64 %idxprom55
  %19 = load ptr, ptr %arrayidx56, align 8, !tbaa !24
  %call57 = call ptr @mk_sym(ptr noundef %st, ptr noundef %19)
  %call58 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 2, ptr noundef %call57, ptr noundef %call50)
  br label %cleanup

cleanup:                                          ; preds = %if.end53, %if.then52
  %retval.0 = phi ptr [ %call58, %if.end53 ], [ null, %if.then52 ]
  br label %cleanup61

if.end59:                                         ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end59
  %add60 = add nsw i32 %i.0, 2
  br label %for.cond, !llvm.loop !59

cleanup61:                                        ; preds = %cleanup, %for.cond.cleanup
  %cleanup.dest.slot.1 = phi i32 [ 1, %cleanup ], [ 2, %for.cond.cleanup ]
  %retval.1 = phi ptr [ %retval.0, %cleanup ], [ undef, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.1, label %unreachable [
    i32 2, label %for.end
    i32 1, label %do.end
  ]

for.end:                                          ; preds = %cleanup61
  %file62 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %20 = load ptr, ptr %file62, align 8, !tbaa !51
  %filec63 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %21 = load i64, ptr %filec63, align 8, !tbaa !52
  %add64 = add i64 %21, 0
  %arrayidx65 = getelementptr inbounds i8, ptr %20, i64 %add64
  %22 = load i8, ptr %arrayidx65, align 1, !tbaa !53
  %call66 = call i32 @is_op(i8 noundef %22)
  %tobool67 = icmp ne i32 %call66, 0
  br i1 %tobool67, label %if.then68, label %if.end70

if.then68:                                        ; preds = %for.end
  %call69 = call ptr @read_sym(ptr noundef %st)
  br label %do.end

if.end70:                                         ; preds = %for.end
  %file71 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %23 = load ptr, ptr %file71, align 8, !tbaa !51
  %filec72 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %24 = load i64, ptr %filec72, align 8, !tbaa !52
  %add73 = add i64 %24, 0
  %arrayidx74 = getelementptr inbounds i8, ptr %23, i64 %add73
  %25 = load i8, ptr %arrayidx74, align 1, !tbaa !53
  %call75 = call i32 @is_sym(i8 noundef %25)
  %tobool76 = icmp ne i32 %call75, 0
  br i1 %tobool76, label %if.then77, label %if.end79

if.then77:                                        ; preds = %if.end70
  %call78 = call ptr @read_sym(ptr noundef %st)
  br label %do.end

if.end79:                                         ; preds = %if.end70
  %file80 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %26 = load ptr, ptr %file80, align 8, !tbaa !51
  %filec81 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %27 = load i64, ptr %filec81, align 8, !tbaa !52
  %add82 = add i64 %27, 0
  %arrayidx83 = getelementptr inbounds i8, ptr %26, i64 %add82
  %28 = load i8, ptr %arrayidx83, align 1, !tbaa !53
  %conv84 = zext i8 %28 to i32
  %cmp85 = icmp eq i32 %conv84, 40
  br i1 %cmp85, label %if.then87, label %if.end90

if.then87:                                        ; preds = %if.end79
  %filec88 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %29 = load i64, ptr %filec88, align 8, !tbaa !52
  %inc = add i64 %29, 1
  store i64 %inc, ptr %filec88, align 8, !tbaa !52
  %call89 = call ptr @read_pair(ptr noundef %st, i8 noundef 41)
  br label %do.end

if.end90:                                         ; preds = %if.end79
  %file91 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %30 = load ptr, ptr %file91, align 8, !tbaa !51
  %filec92 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %31 = load i64, ptr %filec92, align 8, !tbaa !52
  %add93 = add i64 %31, 0
  %arrayidx94 = getelementptr inbounds i8, ptr %30, i64 %add93
  %32 = load i8, ptr %arrayidx94, align 1, !tbaa !53
  %conv95 = zext i8 %32 to i32
  %cmp96 = icmp eq i32 %conv95, 91
  br i1 %cmp96, label %if.then98, label %if.end104

if.then98:                                        ; preds = %if.end90
  %filec99 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %33 = load i64, ptr %filec99, align 8, !tbaa !52
  %inc100 = add i64 %33, 1
  store i64 %inc100, ptr %filec99, align 8, !tbaa !52
  %call101 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.34)
  %call102 = call ptr @read_pair(ptr noundef %st, i8 noundef 93)
  %call103 = call ptr @mk_pair(ptr noundef %call101, ptr noundef %call102)
  br label %do.end

if.end104:                                        ; preds = %if.end90
  %file105 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %34 = load ptr, ptr %file105, align 8, !tbaa !51
  %filec106 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %35 = load i64, ptr %filec106, align 8, !tbaa !52
  %add107 = add i64 %35, 0
  %arrayidx108 = getelementptr inbounds i8, ptr %34, i64 %add107
  %36 = load i8, ptr %arrayidx108, align 1, !tbaa !53
  %conv109 = zext i8 %36 to i32
  %cmp110 = icmp eq i32 %conv109, 123
  br i1 %cmp110, label %if.then112, label %if.end123

if.then112:                                       ; preds = %if.end104
  %filec114 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %37 = load i64, ptr %filec114, align 8, !tbaa !52
  %inc115 = add i64 %37, 1
  store i64 %inc115, ptr %filec114, align 8, !tbaa !52
  %call116 = call ptr @read_pair(ptr noundef %st, i8 noundef 125)
  %tobool117 = icmp ne ptr %call116, null
  br i1 %tobool117, label %if.end119, label %if.then118

if.then118:                                       ; preds = %if.then112
  br label %cleanup122

if.end119:                                        ; preds = %if.then112
  %call120 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.12)
  %call121 = call ptr @mk_pair(ptr noundef %call120, ptr noundef %call116)
  br label %cleanup122

cleanup122:                                       ; preds = %if.end119, %if.then118
  %retval.2 = phi ptr [ %call121, %if.end119 ], [ null, %if.then118 ]
  br label %do.end

if.end123:                                        ; preds = %if.end104
  br label %do.body

do.body:                                          ; preds = %if.end123
  %38 = load ptr, ptr @stderr, align 8, !tbaa !24
  %file124 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %39 = load ptr, ptr %file124, align 8, !tbaa !51
  %filec125 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %40 = load i64, ptr %filec125, align 8, !tbaa !52
  %arrayidx126 = getelementptr inbounds i8, ptr %39, i64 %40
  %41 = load i8, ptr %arrayidx126, align 1, !tbaa !53
  %conv127 = zext i8 %41 to i32
  %file128 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %42 = load ptr, ptr %file128, align 8, !tbaa !51
  %filec129 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %43 = load i64, ptr %filec129, align 8, !tbaa !52
  %arrayidx130 = getelementptr inbounds i8, ptr %42, i64 %43
  %44 = load i8, ptr %arrayidx130, align 1, !tbaa !53
  %conv131 = zext i8 %44 to i32
  %call132 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %38, ptr noundef @.str.35, i32 noundef %conv127, i32 noundef %conv131)
  br label %do.end

do.end:                                           ; preds = %do.body, %cleanup122, %if.then98, %if.then87, %if.then77, %if.then68, %cleanup61, %if.then22, %if.then12, %if.then5, %if.then
  %retval.3 = phi ptr [ %2, %if.then ], [ %call6, %if.then5 ], [ %call13, %if.then12 ], [ %call23, %if.then22 ], [ %retval.1, %cleanup61 ], [ %call69, %if.then68 ], [ %call78, %if.then77 ], [ %call89, %if.then87 ], [ %call103, %if.then98 ], [ %retval.2, %cleanup122 ], [ null, %do.body ]
  ret ptr %retval.3

unreachable:                                      ; preds = %cleanup61
  unreachable
}

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strlen(ptr noundef) #8

; Function Attrs: nounwind uwtable
define internal i32 @isnum(ptr noundef %str) #0 {
entry:
  %call = call ptr @__ctype_b_loc() #14
  %0 = load ptr, ptr %call, align 8, !tbaa !24
  %1 = load i8, ptr %str, align 1, !tbaa !53
  %conv = zext i8 %1 to i32
  %idxprom = sext i32 %conv to i64
  %arrayidx = getelementptr inbounds i16, ptr %0, i64 %idxprom
  %2 = load i16, ptr %arrayidx, align 2, !tbaa !60
  %conv1 = zext i16 %2 to i32
  %and = and i32 %conv1, 2048
  %tobool = icmp ne i32 %and, 0
  br i1 %tobool, label %lor.end32, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %entry
  %3 = load i8, ptr %str, align 1, !tbaa !53
  %conv2 = zext i8 %3 to i32
  %cmp = icmp eq i32 %conv2, 46
  br i1 %cmp, label %land.lhs.true, label %lor.rhs

land.lhs.true:                                    ; preds = %lor.lhs.false
  %call4 = call ptr @__ctype_b_loc() #14
  %4 = load ptr, ptr %call4, align 8, !tbaa !24
  %arrayidx5 = getelementptr inbounds i8, ptr %str, i64 1
  %5 = load i8, ptr %arrayidx5, align 1, !tbaa !53
  %conv6 = zext i8 %5 to i32
  %idxprom7 = sext i32 %conv6 to i64
  %arrayidx8 = getelementptr inbounds i16, ptr %4, i64 %idxprom7
  %6 = load i16, ptr %arrayidx8, align 2, !tbaa !60
  %conv9 = zext i16 %6 to i32
  %and10 = and i32 %conv9, 2048
  %tobool11 = icmp ne i32 %and10, 0
  br i1 %tobool11, label %lor.end32, label %lor.rhs

lor.rhs:                                          ; preds = %land.lhs.true, %lor.lhs.false
  %7 = load i8, ptr %str, align 1, !tbaa !53
  %conv12 = zext i8 %7 to i32
  %cmp13 = icmp eq i32 %conv12, 45
  br i1 %cmp13, label %land.rhs, label %lor.lhs.false15

lor.lhs.false15:                                  ; preds = %lor.rhs
  %8 = load i8, ptr %str, align 1, !tbaa !53
  %conv16 = zext i8 %8 to i32
  %cmp17 = icmp eq i32 %conv16, 43
  br i1 %cmp17, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %lor.lhs.false15, %lor.rhs
  %call19 = call ptr @__ctype_b_loc() #14
  %9 = load ptr, ptr %call19, align 8, !tbaa !24
  %arrayidx20 = getelementptr inbounds i8, ptr %str, i64 1
  %10 = load i8, ptr %arrayidx20, align 1, !tbaa !53
  %conv21 = zext i8 %10 to i32
  %idxprom22 = sext i32 %conv21 to i64
  %arrayidx23 = getelementptr inbounds i16, ptr %9, i64 %idxprom22
  %11 = load i16, ptr %arrayidx23, align 2, !tbaa !60
  %conv24 = zext i16 %11 to i32
  %and25 = and i32 %conv24, 2048
  %tobool26 = icmp ne i32 %and25, 0
  br i1 %tobool26, label %lor.end, label %lor.rhs27

lor.rhs27:                                        ; preds = %land.rhs
  %arrayidx28 = getelementptr inbounds i8, ptr %str, i64 1
  %12 = load i8, ptr %arrayidx28, align 1, !tbaa !53
  %conv29 = zext i8 %12 to i32
  %cmp30 = icmp eq i32 %conv29, 46
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs27, %land.rhs
  %13 = phi i1 [ true, %land.rhs ], [ %cmp30, %lor.rhs27 ]
  br label %land.end

land.end:                                         ; preds = %lor.end, %lor.lhs.false15
  %14 = phi i1 [ false, %lor.lhs.false15 ], [ %13, %lor.end ]
  br label %lor.end32

lor.end32:                                        ; preds = %land.end, %land.lhs.true, %entry
  %15 = phi i1 [ true, %land.lhs.true ], [ true, %entry ], [ %14, %land.end ]
  %lor.ext = zext i1 %15 to i32
  ret i32 %lor.ext
}

; Function Attrs: nounwind uwtable
define internal ptr @read_num(ptr noundef %st) #0 {
entry:
  %call = call i32 @read_sign(ptr noundef %st)
  %call1 = call i32 @read_int(ptr noundef %st)
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  switch i32 %conv, label %sw.default [
    i32 47, label %sw.bb
    i32 46, label %sw.bb10
  ]

sw.bb:                                            ; preds = %entry
  %file2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %3 = load ptr, ptr %file2, align 8, !tbaa !51
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %4 = load i64, ptr %filec3, align 8, !tbaa !52
  %inc = add i64 %4, 1
  store i64 %inc, ptr %filec3, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %3, i64 %inc
  %call4 = call i32 @isnum(ptr noundef %add.ptr)
  %tobool = icmp ne i32 %call4, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %sw.bb
  br label %do.body

do.body:                                          ; preds = %if.then
  %5 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call5 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.125)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end

if.end:                                           ; preds = %do.end, %sw.bb
  %mul = mul nsw i32 %call, %call1
  %call6 = call i32 @read_sign(ptr noundef %st)
  %call7 = call i32 @read_int(ptr noundef %st)
  %mul8 = mul nsw i32 %call6, %call7
  %call9 = call ptr @mk_rat(i32 noundef %mul, i32 noundef %mul8)
  br label %cleanup

sw.bb10:                                          ; preds = %entry
  %filec11 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %6 = load i64, ptr %filec11, align 8, !tbaa !52
  %inc12 = add i64 %6, 1
  store i64 %inc12, ptr %filec11, align 8, !tbaa !52
  %filec13 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %7 = load i64, ptr %filec13, align 8, !tbaa !52
  %call14 = call i32 @read_int(ptr noundef %st)
  %conv15 = sitofp i32 %call14 to double
  %filec16 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %8 = load i64, ptr %filec16, align 8, !tbaa !52
  %sub = sub i64 %8, %7
  %conv17 = trunc i64 %sub to i32
  br label %while.cond

while.cond:                                       ; preds = %while.body, %sw.bb10
  %d.0 = phi double [ %conv15, %sw.bb10 ], [ %div, %while.body ]
  %size.0 = phi i32 [ %conv17, %sw.bb10 ], [ %dec, %while.body ]
  %dec = add nsw i32 %size.0, -1
  %tobool18 = icmp ne i32 %size.0, 0
  br i1 %tobool18, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %div = fdiv double %d.0, 1.000000e+01
  br label %while.cond, !llvm.loop !62

while.end:                                        ; preds = %while.cond
  %conv19 = sitofp i32 %call to double
  %conv20 = sitofp i32 %call1 to double
  %add21 = fadd double %conv20, %d.0
  %mul22 = fmul double %conv19, %add21
  %call23 = call ptr @read_sci(ptr noundef %st, double noundef %mul22, i32 noundef 0)
  br label %cleanup

sw.default:                                       ; preds = %entry
  %mul24 = mul nsw i32 %call, %call1
  %conv25 = sitofp i32 %mul24 to double
  %call26 = call ptr @read_sci(ptr noundef %st, double noundef %conv25, i32 noundef 1)
  br label %cleanup

cleanup:                                          ; preds = %sw.default, %while.end, %if.end, %do.body
  %retval.0 = phi ptr [ %call26, %sw.default ], [ %call23, %while.end ], [ %call9, %if.end ], [ null, %do.body ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define internal ptr @read_str(ptr noundef %st) #0 {
entry:
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %inc = add i64 %1, 1
  store i64 %inc, ptr %filec, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %0, i64 %inc
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %len.0 = phi i32 [ 0, %entry ], [ %inc30, %for.inc ]
  %file1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %2 = load ptr, ptr %file1, align 8, !tbaa !51
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %3 = load i64, ptr %filec2, align 8, !tbaa !52
  %add = add i64 %3, 0
  %arrayidx = getelementptr inbounds i8, ptr %2, i64 %add
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %4 to i32
  %conv3 = zext i8 34 to i32
  %cmp = icmp ne i32 %conv, %conv3
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %file5 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %5 = load ptr, ptr %file5, align 8, !tbaa !51
  %filec6 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %6 = load i64, ptr %filec6, align 8, !tbaa !52
  %add7 = add i64 %6, 0
  %arrayidx8 = getelementptr inbounds i8, ptr %5, i64 %add7
  %7 = load i8, ptr %arrayidx8, align 1, !tbaa !53
  %tobool = icmp ne i8 %7, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %for.body
  br label %do.body

do.body:                                          ; preds = %if.then
  %8 = load ptr, ptr @stderr, align 8, !tbaa !24
  %conv9 = zext i8 34 to i32
  %call = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %8, ptr noundef @.str.126, i32 noundef %conv9)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end27

if.else:                                          ; preds = %for.body
  %file10 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %9 = load ptr, ptr %file10, align 8, !tbaa !51
  %filec11 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %10 = load i64, ptr %filec11, align 8, !tbaa !52
  %add12 = add i64 %10, 0
  %arrayidx13 = getelementptr inbounds i8, ptr %9, i64 %add12
  %11 = load i8, ptr %arrayidx13, align 1, !tbaa !53
  %conv14 = zext i8 %11 to i32
  %cmp15 = icmp eq i32 %conv14, 92
  br i1 %cmp15, label %land.lhs.true, label %if.end

land.lhs.true:                                    ; preds = %if.else
  %file17 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %12 = load ptr, ptr %file17, align 8, !tbaa !51
  %filec18 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %13 = load i64, ptr %filec18, align 8, !tbaa !52
  %add19 = add i64 %13, -1
  %arrayidx20 = getelementptr inbounds i8, ptr %12, i64 %add19
  %14 = load i8, ptr %arrayidx20, align 1, !tbaa !53
  %conv21 = zext i8 %14 to i32
  %cmp22 = icmp ne i32 %conv21, 92
  br i1 %cmp22, label %if.then24, label %if.end

if.then24:                                        ; preds = %land.lhs.true
  %filec25 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %15 = load i64, ptr %filec25, align 8, !tbaa !52
  %inc26 = add i64 %15, 1
  store i64 %inc26, ptr %filec25, align 8, !tbaa !52
  br label %if.end

if.end:                                           ; preds = %if.then24, %land.lhs.true, %if.else
  br label %if.end27

if.end27:                                         ; preds = %if.end, %do.end
  br label %for.inc

for.inc:                                          ; preds = %if.end27
  %filec28 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %16 = load i64, ptr %filec28, align 8, !tbaa !52
  %inc29 = add i64 %16, 1
  store i64 %inc29, ptr %filec28, align 8, !tbaa !52
  %inc30 = add nsw i32 %len.0, 1
  br label %for.cond, !llvm.loop !63

for.end:                                          ; preds = %for.cond
  %filec31 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %17 = load i64, ptr %filec31, align 8, !tbaa !52
  %inc32 = add i64 %17, 1
  store i64 %inc32, ptr %filec31, align 8, !tbaa !52
  %18 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  br label %cleanup

cleanup:                                          ; preds = %for.end, %do.body
  %retval.0 = phi ptr [ null, %do.body ], [ %18, %for.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define internal i32 @is_op(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  %call = call ptr @strchr(ptr noundef @.str.127, i32 noundef %conv) #17
  %cmp = icmp ne ptr %call, null
  %conv1 = zext i1 %cmp to i32
  ret i32 %conv1
}

; Function Attrs: nounwind uwtable
define internal ptr @read_sym(ptr noundef %st) #0 {
entry:
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %0, i64 %1
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %len.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %file1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %2 = load ptr, ptr %file1, align 8, !tbaa !51
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %3 = load i64, ptr %filec2, align 8, !tbaa !52
  %add = add i64 %3, 0
  %arrayidx = getelementptr inbounds i8, ptr %2, i64 %add
  %4 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %tobool = icmp ne i8 %4, 0
  br i1 %tobool, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %inc = add nsw i32 %len.0, 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %5 = load i64, ptr %filec3, align 8, !tbaa !52
  %inc4 = add i64 %5, 1
  store i64 %inc4, ptr %filec3, align 8, !tbaa !52
  br label %for.cond, !llvm.loop !64

for.end:                                          ; preds = %for.cond
  %call = call ptr @esc_str(ptr noundef %add.ptr, i32 noundef %len.0, i32 noundef 0)
  %call5 = call ptr @mk_sym(ptr noundef %st, ptr noundef %call)
  ret ptr %call5
}

; Function Attrs: nounwind uwtable
define internal i32 @is_sym(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  %cmp = icmp sle i32 97, %conv
  br i1 %cmp, label %land.lhs.true, label %lor.lhs.false

land.lhs.true:                                    ; preds = %entry
  %conv2 = zext i8 %c to i32
  %cmp3 = icmp sle i32 %conv2, 122
  br i1 %cmp3, label %lor.end, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %land.lhs.true, %entry
  %conv5 = zext i8 %c to i32
  %cmp6 = icmp sle i32 65, %conv5
  br i1 %cmp6, label %land.lhs.true8, label %lor.lhs.false12

land.lhs.true8:                                   ; preds = %lor.lhs.false
  %conv9 = zext i8 %c to i32
  %cmp10 = icmp sle i32 %conv9, 90
  br i1 %cmp10, label %lor.end, label %lor.lhs.false12

lor.lhs.false12:                                  ; preds = %land.lhs.true8, %lor.lhs.false
  %conv13 = zext i8 %c to i32
  %cmp14 = icmp sle i32 48, %conv13
  br i1 %cmp14, label %land.lhs.true16, label %lor.rhs

land.lhs.true16:                                  ; preds = %lor.lhs.false12
  %conv17 = zext i8 %c to i32
  %cmp18 = icmp sle i32 %conv17, 57
  br i1 %cmp18, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %land.lhs.true16, %lor.lhs.false12
  %conv20 = zext i8 %c to i32
  %call = call ptr @strchr(ptr noundef @.str.128, i32 noundef %conv20) #17
  %tobool = icmp ne ptr %call, null
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %land.lhs.true16, %land.lhs.true8, %land.lhs.true
  %0 = phi i1 [ true, %land.lhs.true16 ], [ true, %land.lhs.true8 ], [ true, %land.lhs.true ], [ %tobool, %lor.rhs ]
  %lor.ext = zext i1 %0 to i32
  ret i32 %lor.ext
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_read_sugar(ptr noundef %st, ptr noundef %v) #0 {
entry:
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  %cmp = icmp eq i32 %conv, 40
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %3 = load i64, ptr %filec2, align 8, !tbaa !52
  %inc = add i64 %3, 1
  store i64 %inc, ptr %filec2, align 8, !tbaa !52
  %call = call ptr @read_pair(ptr noundef %st, i8 noundef 41)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then3

if.then3:                                         ; preds = %if.then
  br label %cleanup

if.end:                                           ; preds = %if.then
  %call4 = call ptr @mk_pair(ptr noundef %v, ptr noundef %call)
  br label %cleanup

if.else:                                          ; preds = %entry
  %file5 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %4 = load ptr, ptr %file5, align 8, !tbaa !51
  %filec6 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %5 = load i64, ptr %filec6, align 8, !tbaa !52
  %add7 = add i64 %5, 0
  %arrayidx8 = getelementptr inbounds i8, ptr %4, i64 %add7
  %6 = load i8, ptr %arrayidx8, align 1, !tbaa !53
  %conv9 = zext i8 %6 to i32
  %cmp10 = icmp eq i32 %conv9, 123
  br i1 %cmp10, label %if.then12, label %if.else23

if.then12:                                        ; preds = %if.else
  %filec13 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %7 = load i64, ptr %filec13, align 8, !tbaa !52
  %inc14 = add i64 %7, 1
  store i64 %inc14, ptr %filec13, align 8, !tbaa !52
  %call15 = call ptr @read_pair(ptr noundef %st, i8 noundef 125)
  %tobool16 = icmp ne ptr %call15, null
  br i1 %tobool16, label %if.end18, label %if.then17

if.then17:                                        ; preds = %if.then12
  br label %cleanup

if.end18:                                         ; preds = %if.then12
  %call19 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.36)
  %call20 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.12)
  %call21 = call ptr @mk_pair(ptr noundef %call20, ptr noundef %call15)
  %call22 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 3, ptr noundef %call19, ptr noundef %v, ptr noundef %call21)
  br label %cleanup

if.else23:                                        ; preds = %if.else
  %file24 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %8 = load ptr, ptr %file24, align 8, !tbaa !51
  %filec25 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %9 = load i64, ptr %filec25, align 8, !tbaa !52
  %add26 = add i64 %9, 0
  %arrayidx27 = getelementptr inbounds i8, ptr %8, i64 %add26
  %10 = load i8, ptr %arrayidx27, align 1, !tbaa !53
  %conv28 = zext i8 %10 to i32
  %cmp29 = icmp eq i32 %conv28, 58
  br i1 %cmp29, label %if.then31, label %if.else63

if.then31:                                        ; preds = %if.else23
  %filec32 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %11 = load i64, ptr %filec32, align 8, !tbaa !52
  %inc33 = add i64 %11, 1
  store i64 %inc33, ptr %filec32, align 8, !tbaa !52
  %file34 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %12 = load ptr, ptr %file34, align 8, !tbaa !51
  %filec35 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %13 = load i64, ptr %filec35, align 8, !tbaa !52
  %add36 = add i64 %13, 0
  %arrayidx37 = getelementptr inbounds i8, ptr %12, i64 %add36
  %14 = load i8, ptr %arrayidx37, align 1, !tbaa !53
  %conv38 = zext i8 %14 to i32
  switch i32 %conv38, label %sw.default [
    i32 40, label %sw.bb
    i32 58, label %sw.bb48
  ]

sw.bb:                                            ; preds = %if.then31
  %filec39 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %15 = load i64, ptr %filec39, align 8, !tbaa !52
  %inc40 = add i64 %15, 1
  store i64 %inc40, ptr %filec39, align 8, !tbaa !52
  %call41 = call ptr @read_pair(ptr noundef %st, i8 noundef 41)
  %tobool42 = icmp ne ptr %call41, null
  br i1 %tobool42, label %if.end44, label %if.then43

if.then43:                                        ; preds = %sw.bb
  br label %cleanup

if.end44:                                         ; preds = %sw.bb
  %call45 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.37)
  %call46 = call ptr @mk_pair(ptr noundef %v, ptr noundef %call41)
  %call47 = call ptr @mk_pair(ptr noundef %call45, ptr noundef %call46)
  br label %cleanup

sw.bb48:                                          ; preds = %if.then31
  %filec49 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %16 = load i64, ptr %filec49, align 8, !tbaa !52
  %inc50 = add i64 %16, 1
  store i64 %inc50, ptr %filec49, align 8, !tbaa !52
  %call51 = call ptr @read_sym(ptr noundef %st)
  %tobool52 = icmp ne ptr %call51, null
  br i1 %tobool52, label %if.end54, label %if.then53

if.then53:                                        ; preds = %sw.bb48
  br label %cleanup

if.end54:                                         ; preds = %sw.bb48
  %call55 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.24)
  %call56 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 2, ptr noundef %call55, ptr noundef %call51)
  %call57 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 2, ptr noundef %v, ptr noundef %call56)
  br label %cleanup

sw.default:                                       ; preds = %if.then31
  call void @skip_ws(ptr noundef %st, i32 noundef 1)
  %call58 = call ptr @tisp_read(ptr noundef %st)
  %tobool59 = icmp ne ptr %call58, null
  br i1 %tobool59, label %if.end61, label %if.then60

if.then60:                                        ; preds = %sw.default
  br label %cleanup

if.end61:                                         ; preds = %sw.default
  %call62 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 2, ptr noundef %v, ptr noundef %call58)
  br label %cleanup

if.else63:                                        ; preds = %if.else23
  %file64 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %17 = load ptr, ptr %file64, align 8, !tbaa !51
  %filec65 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %18 = load i64, ptr %filec65, align 8, !tbaa !52
  %add66 = add i64 %18, 0
  %arrayidx67 = getelementptr inbounds i8, ptr %17, i64 %add66
  %19 = load i8, ptr %arrayidx67, align 1, !tbaa !53
  %conv68 = zext i8 %19 to i32
  %cmp69 = icmp eq i32 %conv68, 62
  br i1 %cmp69, label %land.lhs.true, label %if.end95

land.lhs.true:                                    ; preds = %if.else63
  %file71 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %20 = load ptr, ptr %file71, align 8, !tbaa !51
  %filec72 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %21 = load i64, ptr %filec72, align 8, !tbaa !52
  %add73 = add i64 %21, 1
  %arrayidx74 = getelementptr inbounds i8, ptr %20, i64 %add73
  %22 = load i8, ptr %arrayidx74, align 1, !tbaa !53
  %conv75 = zext i8 %22 to i32
  %cmp76 = icmp eq i32 %conv75, 62
  br i1 %cmp76, label %if.then78, label %if.end95

if.then78:                                        ; preds = %land.lhs.true
  %filec79 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %23 = load i64, ptr %filec79, align 8, !tbaa !52
  %inc80 = add i64 %23, 1
  store i64 %inc80, ptr %filec79, align 8, !tbaa !52
  %filec81 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %24 = load i64, ptr %filec81, align 8, !tbaa !52
  %inc82 = add i64 %24, 1
  store i64 %inc82, ptr %filec81, align 8, !tbaa !52
  %call83 = call ptr @tisp_read(ptr noundef %st)
  %tobool84 = icmp ne ptr %call83, null
  br i1 %tobool84, label %lor.lhs.false, label %if.then87

lor.lhs.false:                                    ; preds = %if.then78
  %t = getelementptr inbounds %struct.Val, ptr %call83, i32 0, i32 0
  %25 = load i32, ptr %t, align 8, !tbaa !6
  %cmp85 = icmp ne i32 %25, 2048
  br i1 %cmp85, label %if.then87, label %if.end89

if.then87:                                        ; preds = %lor.lhs.false, %if.then78
  br label %do.body

do.body:                                          ; preds = %if.then87
  %26 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call88 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %26, ptr noundef @.str.38)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end89

if.end89:                                         ; preds = %do.end, %lor.lhs.false
  %v90 = getelementptr inbounds %struct.Val, ptr %call83, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v90, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %27 = load ptr, ptr %car, align 8, !tbaa !46
  %v91 = getelementptr inbounds %struct.Val, ptr %call83, i32 0, i32 1
  %p92 = getelementptr inbounds %struct.anon, ptr %v91, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p92, i32 0, i32 1
  %28 = load ptr, ptr %cdr, align 8, !tbaa !16
  %call93 = call ptr @mk_pair(ptr noundef %v, ptr noundef %28)
  %call94 = call ptr @mk_pair(ptr noundef %27, ptr noundef %call93)
  br label %cleanup

if.end95:                                         ; preds = %land.lhs.true, %if.else63
  br label %if.end96

if.end96:                                         ; preds = %if.end95
  br label %if.end97

if.end97:                                         ; preds = %if.end96
  br label %if.end98

if.end98:                                         ; preds = %if.end97
  br label %cleanup

cleanup:                                          ; preds = %if.end98, %if.end89, %do.body, %if.end61, %if.then60, %if.end54, %if.then53, %if.end44, %if.then43, %if.end18, %if.then17, %if.end, %if.then3
  %retval.0 = phi ptr [ %call4, %if.end ], [ null, %if.then3 ], [ %call22, %if.end18 ], [ null, %if.then17 ], [ %call62, %if.end61 ], [ null, %if.then60 ], [ %call57, %if.end54 ], [ null, %if.then53 ], [ %call47, %if.end44 ], [ null, %if.then43 ], [ null, %do.body ], [ %call94, %if.end89 ], [ %v, %if.end98 ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_read_line(ptr noundef %st, i32 noundef %level) #0 {
entry:
  %call = call ptr @read_pair(ptr noundef %st, i8 noundef 10)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup44

if.end:                                           ; preds = %entry
  %t = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  %cmp = icmp ne i32 %0, 2048
  br i1 %cmp, label %if.then1, label %if.end3

if.then1:                                         ; preds = %if.end
  %nil = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %1 = load ptr, ptr %nil, align 8, !tbaa !49
  %call2 = call ptr @mk_pair(ptr noundef %call, ptr noundef %1)
  br label %if.end3

if.end3:                                          ; preds = %if.then1, %if.end
  %ret.0 = phi ptr [ %call2, %if.then1 ], [ %call, %if.end ]
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end3
  %pos.0 = phi ptr [ %ret.0, %if.end3 ], [ %4, %for.inc ]
  %v = getelementptr inbounds %struct.Val, ptr %pos.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  %2 = load ptr, ptr %cdr, align 8, !tbaa !16
  %t4 = getelementptr inbounds %struct.Val, ptr %2, i32 0, i32 0
  %3 = load i32, ptr %t4, align 8, !tbaa !6
  %cmp5 = icmp eq i32 %3, 2048
  br i1 %cmp5, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %v6 = getelementptr inbounds %struct.Val, ptr %pos.0, i32 0, i32 1
  %p7 = getelementptr inbounds %struct.anon, ptr %v6, i32 0, i32 4
  %cdr8 = getelementptr inbounds %struct.anon.3, ptr %p7, i32 0, i32 1
  %4 = load ptr, ptr %cdr8, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !65

for.end:                                          ; preds = %for.cond
  br label %for.cond9

for.cond9:                                        ; preds = %for.inc30, %for.end
  %pos.1 = phi ptr [ %pos.0, %for.end ], [ %12, %for.inc30 ]
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %5 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %6 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %6, 0
  %arrayidx = getelementptr inbounds i8, ptr %5, i64 %add
  %7 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %tobool10 = icmp ne i8 %7, 0
  br i1 %tobool10, label %for.body11, label %for.end34

for.body11:                                       ; preds = %for.cond9
  %file12 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %8 = load ptr, ptr %file12, align 8, !tbaa !51
  %filec13 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %9 = load i64, ptr %filec13, align 8, !tbaa !52
  %add.ptr = getelementptr inbounds i8, ptr %8, i64 %9
  %call14 = call i64 @strspn(ptr noundef %add.ptr, ptr noundef @.str.39) #17
  %conv = trunc i64 %call14 to i32
  %cmp15 = icmp sle i32 %conv, %level
  br i1 %cmp15, label %if.then17, label %if.end18

if.then17:                                        ; preds = %for.body11
  br label %cleanup

if.end18:                                         ; preds = %for.body11
  %conv19 = sext i32 %conv to i64
  %filec20 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %10 = load i64, ptr %filec20, align 8, !tbaa !52
  %add21 = add i64 %10, %conv19
  store i64 %add21, ptr %filec20, align 8, !tbaa !52
  %call22 = call ptr @tisp_read_line(ptr noundef %st, i32 noundef %conv)
  %v23 = getelementptr inbounds %struct.Val, ptr %pos.1, i32 0, i32 1
  %p24 = getelementptr inbounds %struct.anon, ptr %v23, i32 0, i32 4
  %cdr25 = getelementptr inbounds %struct.anon.3, ptr %p24, i32 0, i32 1
  %11 = load ptr, ptr %cdr25, align 8, !tbaa !16
  %call26 = call ptr @mk_pair(ptr noundef %call22, ptr noundef %11)
  %v27 = getelementptr inbounds %struct.Val, ptr %pos.1, i32 0, i32 1
  %p28 = getelementptr inbounds %struct.anon, ptr %v27, i32 0, i32 4
  %cdr29 = getelementptr inbounds %struct.anon.3, ptr %p28, i32 0, i32 1
  store ptr %call26, ptr %cdr29, align 8, !tbaa !16
  br label %cleanup

cleanup:                                          ; preds = %if.end18, %if.then17
  %cleanup.dest.slot.0 = phi i32 [ 5, %if.then17 ], [ 0, %if.end18 ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 0, label %cleanup.cont
    i32 5, label %for.end34
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc30

for.inc30:                                        ; preds = %cleanup.cont
  %v31 = getelementptr inbounds %struct.Val, ptr %pos.1, i32 0, i32 1
  %p32 = getelementptr inbounds %struct.anon, ptr %v31, i32 0, i32 4
  %cdr33 = getelementptr inbounds %struct.anon.3, ptr %p32, i32 0, i32 1
  %12 = load ptr, ptr %cdr33, align 8, !tbaa !16
  br label %for.cond9, !llvm.loop !66

for.end34:                                        ; preds = %cleanup, %for.cond9
  %v35 = getelementptr inbounds %struct.Val, ptr %ret.0, i32 0, i32 1
  %p36 = getelementptr inbounds %struct.anon, ptr %v35, i32 0, i32 4
  %cdr37 = getelementptr inbounds %struct.anon.3, ptr %p36, i32 0, i32 1
  %13 = load ptr, ptr %cdr37, align 8, !tbaa !16
  %t38 = getelementptr inbounds %struct.Val, ptr %13, i32 0, i32 0
  %14 = load i32, ptr %t38, align 8, !tbaa !6
  %cmp39 = icmp eq i32 %14, 2
  br i1 %cmp39, label %if.then41, label %if.else

if.then41:                                        ; preds = %for.end34
  %v42 = getelementptr inbounds %struct.Val, ptr %ret.0, i32 0, i32 1
  %p43 = getelementptr inbounds %struct.anon, ptr %v42, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p43, i32 0, i32 0
  %15 = load ptr, ptr %car, align 8, !tbaa !46
  br label %cleanup44

if.else:                                          ; preds = %for.end34
  br label %cleanup44

cleanup44:                                        ; preds = %if.else, %if.then41, %if.then
  %retval.0 = phi ptr [ %15, %if.then41 ], [ %ret.0, %if.else ], [ null, %if.then ]
  ret ptr %retval.0

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strspn(ptr noundef, ptr noundef) #8

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_eval_list(ptr noundef %st, ptr noundef %env, ptr noundef %v) #0 {
entry:
  %nil = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %0 = load ptr, ptr %nil, align 8, !tbaa !49
  %call = call ptr @mk_pair(ptr noundef null, ptr noundef %0)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %v.addr.0 = phi ptr [ %v, %entry ], [ %6, %for.inc ]
  %cur.0 = phi ptr [ %call, %entry ], [ %7, %for.inc ]
  %t = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %1 = load i32, ptr %t, align 8, !tbaa !6
  %cmp = icmp eq i32 %1, 2
  %lnot = xor i1 %cmp, true
  br i1 %lnot, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
  %t1 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %2 = load i32, ptr %t1, align 8, !tbaa !6
  %cmp2 = icmp ne i32 %2, 2048
  br i1 %cmp2, label %if.then, label %if.end9

if.then:                                          ; preds = %for.body
  %call3 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env, ptr noundef %v.addr.0)
  %tobool = icmp ne ptr %call3, null
  br i1 %tobool, label %if.end, label %if.then4

if.then4:                                         ; preds = %if.then
  br label %cleanup

if.end:                                           ; preds = %if.then
  %v5 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v5, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  store ptr %call3, ptr %cdr, align 8, !tbaa !16
  %v6 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %p7 = getelementptr inbounds %struct.anon, ptr %v6, i32 0, i32 4
  %cdr8 = getelementptr inbounds %struct.anon.3, ptr %p7, i32 0, i32 1
  %3 = load ptr, ptr %cdr8, align 8, !tbaa !16
  br label %cleanup

if.end9:                                          ; preds = %for.body
  %v10 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p11 = getelementptr inbounds %struct.anon, ptr %v10, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p11, i32 0, i32 0
  %4 = load ptr, ptr %car, align 8, !tbaa !46
  %call12 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env, ptr noundef %4)
  %tobool13 = icmp ne ptr %call12, null
  br i1 %tobool13, label %if.end15, label %if.then14

if.then14:                                        ; preds = %if.end9
  br label %cleanup

if.end15:                                         ; preds = %if.end9
  %nil16 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 3
  %5 = load ptr, ptr %nil16, align 8, !tbaa !49
  %call17 = call ptr @mk_pair(ptr noundef %call12, ptr noundef %5)
  %v18 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p19 = getelementptr inbounds %struct.anon, ptr %v18, i32 0, i32 4
  %cdr20 = getelementptr inbounds %struct.anon.3, ptr %p19, i32 0, i32 1
  store ptr %call17, ptr %cdr20, align 8, !tbaa !16
  br label %for.inc

for.inc:                                          ; preds = %if.end15
  %v21 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p22 = getelementptr inbounds %struct.anon, ptr %v21, i32 0, i32 4
  %cdr23 = getelementptr inbounds %struct.anon.3, ptr %p22, i32 0, i32 1
  %6 = load ptr, ptr %cdr23, align 8, !tbaa !16
  %v24 = getelementptr inbounds %struct.Val, ptr %cur.0, i32 0, i32 1
  %p25 = getelementptr inbounds %struct.anon, ptr %v24, i32 0, i32 4
  %cdr26 = getelementptr inbounds %struct.anon.3, ptr %p25, i32 0, i32 1
  %7 = load ptr, ptr %cdr26, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !67

cleanup:                                          ; preds = %if.then14, %if.end, %if.then4, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.end ], [ 1, %if.then4 ], [ 1, %if.then14 ], [ 2, %for.cond.cleanup ]
  %retval.0 = phi ptr [ %3, %if.end ], [ null, %if.then4 ], [ null, %if.then14 ], [ undef, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %cleanup30 [
    i32 2, label %for.end
  ]

for.end:                                          ; preds = %cleanup
  %v27 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %p28 = getelementptr inbounds %struct.anon, ptr %v27, i32 0, i32 4
  %cdr29 = getelementptr inbounds %struct.anon.3, ptr %p28, i32 0, i32 1
  %8 = load ptr, ptr %cdr29, align 8, !tbaa !16
  br label %cleanup30

cleanup30:                                        ; preds = %for.end, %cleanup
  %retval.1 = phi ptr [ %retval.0, %cleanup ], [ %8, %for.end ]
  ret ptr %retval.1
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_eval_body(ptr noundef %st, ptr noundef %env, ptr noundef %v) #0 {
entry:
  %none = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 2
  %0 = load ptr, ptr %none, align 8, !tbaa !58
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %ret.0 = phi ptr [ %0, %entry ], [ %ret.1, %for.inc ]
  %v.addr.0 = phi ptr [ %v, %entry ], [ %27, %for.inc ]
  %env.addr.0 = phi ptr [ %env, %entry ], [ %env.addr.3, %for.inc ]
  %retval.0 = phi ptr [ undef, %entry ], [ %retval.3, %for.inc ]
  %t = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %1 = load i32, ptr %t, align 8, !tbaa !6
  %cmp = icmp eq i32 %1, 2048
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %v1 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v1, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 1
  %2 = load ptr, ptr %cdr, align 8, !tbaa !16
  %t2 = getelementptr inbounds %struct.Val, ptr %2, i32 0, i32 0
  %3 = load i32, ptr %t2, align 8, !tbaa !6
  %cmp3 = icmp eq i32 %3, 2
  br i1 %cmp3, label %land.lhs.true, label %if.else95

land.lhs.true:                                    ; preds = %for.body
  %v4 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p5 = getelementptr inbounds %struct.anon, ptr %v4, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p5, i32 0, i32 0
  %4 = load ptr, ptr %car, align 8, !tbaa !46
  %t6 = getelementptr inbounds %struct.Val, ptr %4, i32 0, i32 0
  %5 = load i32, ptr %t6, align 8, !tbaa !6
  %cmp7 = icmp eq i32 %5, 2048
  br i1 %cmp7, label %if.then, label %if.else95

if.then:                                          ; preds = %land.lhs.true
  %v8 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p9 = getelementptr inbounds %struct.anon, ptr %v8, i32 0, i32 4
  %car10 = getelementptr inbounds %struct.anon.3, ptr %p9, i32 0, i32 0
  %6 = load ptr, ptr %car10, align 8, !tbaa !46
  %v11 = getelementptr inbounds %struct.Val, ptr %6, i32 0, i32 1
  %p12 = getelementptr inbounds %struct.anon, ptr %v11, i32 0, i32 4
  %car13 = getelementptr inbounds %struct.anon.3, ptr %p12, i32 0, i32 0
  %7 = load ptr, ptr %car13, align 8, !tbaa !46
  %call = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env.addr.0, ptr noundef %7)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then14

if.then14:                                        ; preds = %if.then
  br label %cleanup93

if.end:                                           ; preds = %if.then
  %t15 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 0
  %8 = load i32, ptr %t15, align 8, !tbaa !6
  %cmp16 = icmp ne i32 %8, 512
  br i1 %cmp16, label %if.then17, label %if.end25

if.then17:                                        ; preds = %if.end
  %v18 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p19 = getelementptr inbounds %struct.anon, ptr %v18, i32 0, i32 4
  %car20 = getelementptr inbounds %struct.anon.3, ptr %p19, i32 0, i32 0
  %9 = load ptr, ptr %car20, align 8, !tbaa !46
  %v21 = getelementptr inbounds %struct.Val, ptr %9, i32 0, i32 1
  %p22 = getelementptr inbounds %struct.anon, ptr %v21, i32 0, i32 4
  %cdr23 = getelementptr inbounds %struct.anon.3, ptr %p22, i32 0, i32 1
  %10 = load ptr, ptr %cdr23, align 8, !tbaa !16
  %call24 = call ptr @eval_proc(ptr noundef %st, ptr noundef %env.addr.0, ptr noundef %call, ptr noundef %10)
  br label %cleanup93

if.end25:                                         ; preds = %if.end
  %v26 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f27 = getelementptr inbounds %struct.anon, ptr %v26, i32 0, i32 3
  %name28 = getelementptr inbounds %struct.anon.2, ptr %f27, i32 0, i32 0
  %11 = load ptr, ptr %name28, align 8, !tbaa !41
  %tobool29 = icmp ne ptr %11, null
  br i1 %tobool29, label %if.then30, label %if.else

if.then30:                                        ; preds = %if.end25
  %v31 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f32 = getelementptr inbounds %struct.anon, ptr %v31, i32 0, i32 3
  %name33 = getelementptr inbounds %struct.anon.2, ptr %f32, i32 0, i32 0
  %12 = load ptr, ptr %name33, align 8, !tbaa !41
  br label %if.end34

if.else:                                          ; preds = %if.end25
  br label %if.end34

if.end34:                                         ; preds = %if.else, %if.then30
  %name.0 = phi ptr [ %12, %if.then30 ], [ @.str.40, %if.else ]
  br label %do.body

do.body:                                          ; preds = %if.end34
  %v35 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f36 = getelementptr inbounds %struct.anon, ptr %v35, i32 0, i32 3
  %args37 = getelementptr inbounds %struct.anon.2, ptr %f36, i32 0, i32 1
  %13 = load ptr, ptr %args37, align 8, !tbaa !42
  %call38 = call i32 @tsp_lstlen(ptr noundef %13)
  %cmp39 = icmp sgt i32 %call38, -1
  br i1 %cmp39, label %land.lhs.true40, label %if.end67

land.lhs.true40:                                  ; preds = %do.body
  %v41 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p42 = getelementptr inbounds %struct.anon, ptr %v41, i32 0, i32 4
  %car43 = getelementptr inbounds %struct.anon.3, ptr %p42, i32 0, i32 0
  %14 = load ptr, ptr %car43, align 8, !tbaa !46
  %v44 = getelementptr inbounds %struct.Val, ptr %14, i32 0, i32 1
  %p45 = getelementptr inbounds %struct.anon, ptr %v44, i32 0, i32 4
  %cdr46 = getelementptr inbounds %struct.anon.3, ptr %p45, i32 0, i32 1
  %15 = load ptr, ptr %cdr46, align 8, !tbaa !16
  %call47 = call i32 @tsp_lstlen(ptr noundef %15)
  %v48 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f49 = getelementptr inbounds %struct.anon, ptr %v48, i32 0, i32 3
  %args50 = getelementptr inbounds %struct.anon.2, ptr %f49, i32 0, i32 1
  %16 = load ptr, ptr %args50, align 8, !tbaa !42
  %call51 = call i32 @tsp_lstlen(ptr noundef %16)
  %cmp52 = icmp ne i32 %call47, %call51
  br i1 %cmp52, label %if.then53, label %if.end67

if.then53:                                        ; preds = %land.lhs.true40
  br label %do.body54

do.body54:                                        ; preds = %if.then53
  %17 = load ptr, ptr @stderr, align 8, !tbaa !24
  %v55 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f56 = getelementptr inbounds %struct.anon, ptr %v55, i32 0, i32 3
  %args57 = getelementptr inbounds %struct.anon.2, ptr %f56, i32 0, i32 1
  %18 = load ptr, ptr %args57, align 8, !tbaa !42
  %call58 = call i32 @tsp_lstlen(ptr noundef %18)
  %v59 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p60 = getelementptr inbounds %struct.anon, ptr %v59, i32 0, i32 4
  %car61 = getelementptr inbounds %struct.anon.3, ptr %p60, i32 0, i32 0
  %19 = load ptr, ptr %car61, align 8, !tbaa !46
  %v62 = getelementptr inbounds %struct.Val, ptr %19, i32 0, i32 1
  %p63 = getelementptr inbounds %struct.anon, ptr %v62, i32 0, i32 4
  %cdr64 = getelementptr inbounds %struct.anon.3, ptr %p63, i32 0, i32 1
  %20 = load ptr, ptr %cdr64, align 8, !tbaa !16
  %call65 = call i32 @tsp_lstlen(ptr noundef %20)
  %call66 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %17, ptr noundef @.str.41, ptr noundef %name.0, i32 noundef %call58, ptr noundef @.str.42, i32 noundef %call65)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end67

if.end67:                                         ; preds = %do.end, %land.lhs.true40, %do.body
  br label %do.cond68

do.cond68:                                        ; preds = %if.end67
  br label %do.end69

do.end69:                                         ; preds = %do.cond68
  %v70 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p71 = getelementptr inbounds %struct.anon, ptr %v70, i32 0, i32 4
  %car72 = getelementptr inbounds %struct.anon.3, ptr %p71, i32 0, i32 0
  %21 = load ptr, ptr %car72, align 8, !tbaa !46
  %v73 = getelementptr inbounds %struct.Val, ptr %21, i32 0, i32 1
  %p74 = getelementptr inbounds %struct.anon, ptr %v73, i32 0, i32 4
  %cdr75 = getelementptr inbounds %struct.anon.3, ptr %p74, i32 0, i32 1
  %22 = load ptr, ptr %cdr75, align 8, !tbaa !16
  %call76 = call ptr @tisp_eval_list(ptr noundef %st, ptr noundef %env.addr.0, ptr noundef %22)
  %tobool77 = icmp ne ptr %call76, null
  br i1 %tobool77, label %if.end79, label %if.then78

if.then78:                                        ; preds = %do.end69
  br label %cleanup

if.end79:                                         ; preds = %do.end69
  %v80 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f81 = getelementptr inbounds %struct.anon, ptr %v80, i32 0, i32 3
  %env82 = getelementptr inbounds %struct.anon.2, ptr %f81, i32 0, i32 3
  %23 = load ptr, ptr %env82, align 8, !tbaa !44
  %v83 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f84 = getelementptr inbounds %struct.anon, ptr %v83, i32 0, i32 3
  %args85 = getelementptr inbounds %struct.anon.2, ptr %f84, i32 0, i32 1
  %24 = load ptr, ptr %args85, align 8, !tbaa !42
  %call86 = call ptr @rec_extend(ptr noundef %23, ptr noundef %24, ptr noundef %call76)
  %tobool87 = icmp ne ptr %call86, null
  br i1 %tobool87, label %if.end89, label %if.then88

if.then88:                                        ; preds = %if.end79
  br label %cleanup

if.end89:                                         ; preds = %if.end79
  %v90 = getelementptr inbounds %struct.Val, ptr %call, i32 0, i32 1
  %f91 = getelementptr inbounds %struct.anon, ptr %v90, i32 0, i32 3
  %body = getelementptr inbounds %struct.anon.2, ptr %f91, i32 0, i32 2
  %25 = load ptr, ptr %body, align 8, !tbaa !43
  %call92 = call ptr @mk_pair(ptr noundef null, ptr noundef %25)
  br label %cleanup

cleanup:                                          ; preds = %if.end89, %if.then88, %if.then78, %do.body54
  %cleanup.dest.slot.0 = phi i32 [ 1, %do.body54 ], [ 0, %if.end89 ], [ 1, %if.then88 ], [ 1, %if.then78 ]
  %v.addr.1 = phi ptr [ %v.addr.0, %do.body54 ], [ %call92, %if.end89 ], [ %v.addr.0, %if.then88 ], [ %v.addr.0, %if.then78 ]
  %env.addr.1 = phi ptr [ %env.addr.0, %do.body54 ], [ %call86, %if.end89 ], [ %call86, %if.then88 ], [ %env.addr.0, %if.then78 ]
  %retval.1 = phi ptr [ null, %do.body54 ], [ %retval.0, %if.end89 ], [ null, %if.then88 ], [ null, %if.then78 ]
  br label %cleanup93

cleanup93:                                        ; preds = %cleanup, %if.then17, %if.then14
  %cleanup.dest.slot.1 = phi i32 [ 1, %if.then17 ], [ %cleanup.dest.slot.0, %cleanup ], [ 1, %if.then14 ]
  %v.addr.2 = phi ptr [ %v.addr.0, %if.then17 ], [ %v.addr.1, %cleanup ], [ %v.addr.0, %if.then14 ]
  %env.addr.2 = phi ptr [ %env.addr.0, %if.then17 ], [ %env.addr.1, %cleanup ], [ %env.addr.0, %if.then14 ]
  %retval.2 = phi ptr [ %call24, %if.then17 ], [ %retval.1, %cleanup ], [ null, %if.then14 ]
  switch i32 %cleanup.dest.slot.1, label %cleanup107 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup93
  br label %if.end103

if.else95:                                        ; preds = %land.lhs.true, %for.body
  %v96 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p97 = getelementptr inbounds %struct.anon, ptr %v96, i32 0, i32 4
  %car98 = getelementptr inbounds %struct.anon.3, ptr %p97, i32 0, i32 0
  %26 = load ptr, ptr %car98, align 8, !tbaa !46
  %call99 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env.addr.0, ptr noundef %26)
  %tobool100 = icmp ne ptr %call99, null
  br i1 %tobool100, label %if.end102, label %if.then101

if.then101:                                       ; preds = %if.else95
  br label %cleanup107

if.end102:                                        ; preds = %if.else95
  br label %if.end103

if.end103:                                        ; preds = %if.end102, %cleanup.cont
  %ret.1 = phi ptr [ %ret.0, %cleanup.cont ], [ %call99, %if.end102 ]
  %v.addr.3 = phi ptr [ %v.addr.2, %cleanup.cont ], [ %v.addr.0, %if.end102 ]
  %env.addr.3 = phi ptr [ %env.addr.2, %cleanup.cont ], [ %env.addr.0, %if.end102 ]
  %retval.3 = phi ptr [ %retval.2, %cleanup.cont ], [ %retval.0, %if.end102 ]
  br label %for.inc

for.inc:                                          ; preds = %if.end103
  %v104 = getelementptr inbounds %struct.Val, ptr %v.addr.3, i32 0, i32 1
  %p105 = getelementptr inbounds %struct.anon, ptr %v104, i32 0, i32 4
  %cdr106 = getelementptr inbounds %struct.anon.3, ptr %p105, i32 0, i32 1
  %27 = load ptr, ptr %cdr106, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !68

for.end:                                          ; preds = %for.cond
  br label %cleanup107

cleanup107:                                       ; preds = %for.end, %if.then101, %cleanup93
  %retval.4 = phi ptr [ %retval.2, %cleanup93 ], [ null, %if.then101 ], [ %ret.0, %for.end ]
  ret ptr %retval.4
}

; Function Attrs: nounwind uwtable
define internal ptr @eval_proc(ptr noundef %st, ptr noundef %env, ptr noundef %f, ptr noundef %args) #0 {
entry:
  %t = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  switch i32 %0, label %sw.default [
    i32 128, label %sw.bb
    i32 256, label %sw.bb1
    i32 512, label %sw.bb3
    i32 1024, label %sw.bb8
    i32 4096, label %sw.bb59
  ]

sw.bb:                                            ; preds = %entry
  %call = call ptr @tisp_eval_list(ptr noundef %st, ptr noundef %env, ptr noundef %args)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %sw.bb
  br label %cleanup

if.end:                                           ; preds = %sw.bb
  br label %sw.bb1

sw.bb1:                                           ; preds = %if.end, %entry
  %args.addr.0 = phi ptr [ %args, %entry ], [ %call, %if.end ]
  %call2 = call ptr @prim_func(ptr noundef %st, ptr noundef %env, ptr noundef %args.addr.0)
  br label %cleanup

sw.bb3:                                           ; preds = %entry
  %call4 = call ptr @tisp_eval_list(ptr noundef %st, ptr noundef %env, ptr noundef %args)
  %tobool5 = icmp ne ptr %call4, null
  br i1 %tobool5, label %if.end7, label %if.then6

if.then6:                                         ; preds = %sw.bb3
  br label %cleanup

if.end7:                                          ; preds = %sw.bb3
  br label %sw.bb8

sw.bb8:                                           ; preds = %if.end7, %entry
  %args.addr.1 = phi ptr [ %args, %entry ], [ %call4, %if.end7 ]
  %v = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f9 = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 3
  %name10 = getelementptr inbounds %struct.anon.2, ptr %f9, i32 0, i32 0
  %1 = load ptr, ptr %name10, align 8, !tbaa !41
  %tobool11 = icmp ne ptr %1, null
  br i1 %tobool11, label %if.then12, label %if.else

if.then12:                                        ; preds = %sw.bb8
  %v13 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f14 = getelementptr inbounds %struct.anon, ptr %v13, i32 0, i32 3
  %name15 = getelementptr inbounds %struct.anon.2, ptr %f14, i32 0, i32 0
  %2 = load ptr, ptr %name15, align 8, !tbaa !41
  br label %if.end16

if.else:                                          ; preds = %sw.bb8
  br label %if.end16

if.end16:                                         ; preds = %if.else, %if.then12
  %name.0 = phi ptr [ %2, %if.then12 ], [ @.str.40, %if.else ]
  br label %do.body

do.body:                                          ; preds = %if.end16
  %v17 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f18 = getelementptr inbounds %struct.anon, ptr %v17, i32 0, i32 3
  %args19 = getelementptr inbounds %struct.anon.2, ptr %f18, i32 0, i32 1
  %3 = load ptr, ptr %args19, align 8, !tbaa !42
  %call20 = call i32 @tsp_lstlen(ptr noundef %3)
  %cmp = icmp sgt i32 %call20, -1
  br i1 %cmp, label %land.lhs.true, label %if.end35

land.lhs.true:                                    ; preds = %do.body
  %call21 = call i32 @tsp_lstlen(ptr noundef %args.addr.1)
  %v22 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f23 = getelementptr inbounds %struct.anon, ptr %v22, i32 0, i32 3
  %args24 = getelementptr inbounds %struct.anon.2, ptr %f23, i32 0, i32 1
  %4 = load ptr, ptr %args24, align 8, !tbaa !42
  %call25 = call i32 @tsp_lstlen(ptr noundef %4)
  %cmp26 = icmp ne i32 %call21, %call25
  br i1 %cmp26, label %if.then27, label %if.end35

if.then27:                                        ; preds = %land.lhs.true
  br label %do.body28

do.body28:                                        ; preds = %if.then27
  %5 = load ptr, ptr @stderr, align 8, !tbaa !24
  %v29 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f30 = getelementptr inbounds %struct.anon, ptr %v29, i32 0, i32 3
  %args31 = getelementptr inbounds %struct.anon.2, ptr %f30, i32 0, i32 1
  %6 = load ptr, ptr %args31, align 8, !tbaa !42
  %call32 = call i32 @tsp_lstlen(ptr noundef %6)
  %call33 = call i32 @tsp_lstlen(ptr noundef %args.addr.1)
  %call34 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.41, ptr noundef %name.0, i32 noundef %call32, ptr noundef @.str.42, i32 noundef %call33)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end35

if.end35:                                         ; preds = %do.end, %land.lhs.true, %do.body
  br label %do.cond36

do.cond36:                                        ; preds = %if.end35
  br label %do.end37

do.end37:                                         ; preds = %do.cond36
  %v38 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f39 = getelementptr inbounds %struct.anon, ptr %v38, i32 0, i32 3
  %env40 = getelementptr inbounds %struct.anon.2, ptr %f39, i32 0, i32 3
  %7 = load ptr, ptr %env40, align 8, !tbaa !44
  %v41 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f42 = getelementptr inbounds %struct.anon, ptr %v41, i32 0, i32 3
  %args43 = getelementptr inbounds %struct.anon.2, ptr %f42, i32 0, i32 1
  %8 = load ptr, ptr %args43, align 8, !tbaa !42
  %call44 = call ptr @rec_extend(ptr noundef %7, ptr noundef %8, ptr noundef %args.addr.1)
  %tobool45 = icmp ne ptr %call44, null
  br i1 %tobool45, label %if.end47, label %if.then46

if.then46:                                        ; preds = %do.end37
  br label %cleanup

if.end47:                                         ; preds = %do.end37
  %v48 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f49 = getelementptr inbounds %struct.anon, ptr %v48, i32 0, i32 3
  %body = getelementptr inbounds %struct.anon.2, ptr %f49, i32 0, i32 2
  %9 = load ptr, ptr %body, align 8, !tbaa !43
  %call50 = call ptr @tisp_eval_body(ptr noundef %st, ptr noundef %call44, ptr noundef %9)
  %tobool51 = icmp ne ptr %call50, null
  br i1 %tobool51, label %if.end53, label %if.then52

if.then52:                                        ; preds = %if.end47
  call void @prepend_bt(ptr noundef %st, ptr noundef %env, ptr noundef %f)
  br label %cleanup

if.end53:                                         ; preds = %if.end47
  %t54 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 0
  %10 = load i32, ptr %t54, align 8, !tbaa !6
  %cmp55 = icmp eq i32 %10, 1024
  br i1 %cmp55, label %if.then56, label %if.end58

if.then56:                                        ; preds = %if.end53
  %call57 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %env, ptr noundef %call50)
  br label %if.end58

if.end58:                                         ; preds = %if.then56, %if.end53
  %ret.0 = phi ptr [ %call57, %if.then56 ], [ %call50, %if.end53 ]
  br label %cleanup

sw.bb59:                                          ; preds = %entry
  %call60 = call ptr @tisp_eval_list(ptr noundef %st, ptr noundef %env, ptr noundef %args)
  %tobool61 = icmp ne ptr %call60, null
  br i1 %tobool61, label %if.end63, label %if.then62

if.then62:                                        ; preds = %sw.bb59
  br label %cleanup

if.end63:                                         ; preds = %sw.bb59
  br label %do.body64

do.body64:                                        ; preds = %if.end63
  %call65 = call i32 @tsp_lstlen(ptr noundef %call60)
  %cmp66 = icmp ne i32 %call65, 1
  br i1 %cmp66, label %if.then67, label %if.end73

if.then67:                                        ; preds = %do.body64
  br label %do.body68

do.body68:                                        ; preds = %if.then67
  %11 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call69 = call i32 @tsp_lstlen(ptr noundef %call60)
  %call70 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %11, ptr noundef @.str.41, ptr noundef @.str.130, i32 noundef 1, ptr noundef @.str.42, i32 noundef %call69)
  br label %cleanup

do.cond71:                                        ; No predecessors!
  br label %do.end72

do.end72:                                         ; preds = %do.cond71
  br label %if.end73

if.end73:                                         ; preds = %do.end72, %do.body64
  br label %do.cond74

do.cond74:                                        ; preds = %if.end73
  br label %do.end75

do.end75:                                         ; preds = %do.cond74
  br label %do.body76

do.body76:                                        ; preds = %do.end75
  %v77 = getelementptr inbounds %struct.Val, ptr %call60, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v77, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %12 = load ptr, ptr %car, align 8, !tbaa !46
  %t78 = getelementptr inbounds %struct.Val, ptr %12, i32 0, i32 0
  %13 = load i32, ptr %t78, align 8, !tbaa !6
  %and = and i32 %13, 64
  %tobool79 = icmp ne i32 %and, 0
  br i1 %tobool79, label %if.end91, label %if.then80

if.then80:                                        ; preds = %do.body76
  br label %do.body81

do.body81:                                        ; preds = %if.then80
  %14 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call82 = call ptr @tsp_type_str(i32 noundef 64)
  %v83 = getelementptr inbounds %struct.Val, ptr %call60, i32 0, i32 1
  %p84 = getelementptr inbounds %struct.anon, ptr %v83, i32 0, i32 4
  %car85 = getelementptr inbounds %struct.anon.3, ptr %p84, i32 0, i32 0
  %15 = load ptr, ptr %car85, align 8, !tbaa !46
  %t86 = getelementptr inbounds %struct.Val, ptr %15, i32 0, i32 0
  %16 = load i32, ptr %t86, align 8, !tbaa !6
  %call87 = call ptr @tsp_type_str(i32 noundef %16)
  %call88 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.131, ptr noundef %call82, ptr noundef %call87)
  br label %cleanup

do.cond89:                                        ; No predecessors!
  br label %do.end90

do.end90:                                         ; preds = %do.cond89
  br label %if.end91

if.end91:                                         ; preds = %do.end90, %do.body76
  br label %do.cond92

do.cond92:                                        ; preds = %if.end91
  br label %do.end93

do.end93:                                         ; preds = %do.cond92
  %v94 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %r = getelementptr inbounds %struct.anon, ptr %v94, i32 0, i32 5
  %17 = load ptr, ptr %r, align 8, !tbaa !45
  %v95 = getelementptr inbounds %struct.Val, ptr %call60, i32 0, i32 1
  %p96 = getelementptr inbounds %struct.anon, ptr %v95, i32 0, i32 4
  %car97 = getelementptr inbounds %struct.anon.3, ptr %p96, i32 0, i32 0
  %18 = load ptr, ptr %car97, align 8, !tbaa !46
  %v98 = getelementptr inbounds %struct.Val, ptr %18, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v98, i32 0, i32 0
  %19 = load ptr, ptr %s, align 8, !tbaa !29
  %call99 = call ptr @rec_get(ptr noundef %17, ptr noundef %19)
  %tobool100 = icmp ne ptr %call99, null
  br i1 %tobool100, label %if.end116, label %land.lhs.true101

land.lhs.true101:                                 ; preds = %do.end93
  %v102 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %r103 = getelementptr inbounds %struct.anon, ptr %v102, i32 0, i32 5
  %20 = load ptr, ptr %r103, align 8, !tbaa !45
  %call104 = call ptr @rec_get(ptr noundef %20, ptr noundef @.str.132)
  %tobool105 = icmp ne ptr %call104, null
  br i1 %tobool105, label %if.end116, label %if.then106

if.then106:                                       ; preds = %land.lhs.true101
  br label %do.body107

do.body107:                                       ; preds = %if.then106
  %21 = load ptr, ptr @stderr, align 8, !tbaa !24
  %v108 = getelementptr inbounds %struct.Val, ptr %call60, i32 0, i32 1
  %p109 = getelementptr inbounds %struct.anon, ptr %v108, i32 0, i32 4
  %car110 = getelementptr inbounds %struct.anon.3, ptr %p109, i32 0, i32 0
  %22 = load ptr, ptr %car110, align 8, !tbaa !46
  %v111 = getelementptr inbounds %struct.Val, ptr %22, i32 0, i32 1
  %s112 = getelementptr inbounds %struct.anon, ptr %v111, i32 0, i32 0
  %23 = load ptr, ptr %s112, align 8, !tbaa !29
  %call113 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %21, ptr noundef @.str.133, ptr noundef %23)
  br label %cleanup

do.cond114:                                       ; No predecessors!
  br label %do.end115

do.end115:                                        ; preds = %do.cond114
  br label %if.end116

if.end116:                                        ; preds = %do.end115, %land.lhs.true101, %do.end93
  %ret.1 = phi ptr [ %call99, %do.end93 ], [ %call104, %land.lhs.true101 ], [ poison, %do.end115 ]
  br label %cleanup

sw.default:                                       ; preds = %entry
  br label %do.body117

do.body117:                                       ; preds = %sw.default
  %24 = load ptr, ptr @stderr, align 8, !tbaa !24
  %t118 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 0
  %25 = load i32, ptr %t118, align 8, !tbaa !6
  %call119 = call ptr @tsp_type_str(i32 noundef %25)
  %call120 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %24, ptr noundef @.str.134, ptr noundef %call119)
  br label %cleanup

do.cond121:                                       ; No predecessors!
  br label %do.end122

do.end122:                                        ; preds = %do.cond121
  br label %sw.epilog

sw.epilog:                                        ; preds = %do.end122
  store i32 0, ptr poison, align 4
  br label %cleanup

cleanup:                                          ; preds = %sw.epilog, %do.body117, %if.end116, %do.body107, %do.body81, %do.body68, %if.then62, %if.end58, %if.then52, %if.then46, %do.body28, %if.then6, %sw.bb1, %if.then
  %retval.0 = phi ptr [ null, %do.body117 ], [ null, %do.body68 ], [ %ret.1, %if.end116 ], [ null, %do.body107 ], [ null, %do.body81 ], [ null, %if.then62 ], [ null, %do.body28 ], [ %ret.0, %if.end58 ], [ null, %if.then52 ], [ null, %if.then46 ], [ null, %if.then6 ], [ %call2, %sw.bb1 ], [ null, %if.then ], [ poison, %sw.epilog ]
  switch i32 1, label %unreachable [
    i32 0, label %cleanup.cont
    i32 1, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup, %cleanup
  ret ptr %retval.0

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: nounwind uwtable
define internal ptr @rec_extend(ptr noundef %rec, ptr noundef %args, ptr noundef %vals) #0 {
entry:
  %call = call i32 @tsp_lstlen(ptr noundef %args)
  %mul = mul nsw i32 2, %call
  %cmp = icmp sgt i32 %mul, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  %sub = sub nsw i32 0, %mul
  %add = add nsw i32 %sub, 1
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %tmp.0 = phi i32 [ %mul, %if.then ], [ %add, %if.else ]
  %conv = sext i32 %tmp.0 to i64
  %call1 = call ptr @rec_new(i64 noundef %conv, ptr noundef %rec)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %vals.addr.0 = phi ptr [ %vals, %if.end ], [ %10, %for.inc ]
  %args.addr.0 = phi ptr [ %args, %if.end ], [ %9, %for.inc ]
  %t = getelementptr inbounds %struct.Val, ptr %args.addr.0, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  %cmp2 = icmp eq i32 %0, 2
  %lnot = xor i1 %cmp2, true
  br i1 %lnot, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %t4 = getelementptr inbounds %struct.Val, ptr %args.addr.0, i32 0, i32 0
  %1 = load i32, ptr %t4, align 8, !tbaa !6
  %cmp5 = icmp eq i32 %1, 2048
  br i1 %cmp5, label %if.then7, label %if.else11

if.then7:                                         ; preds = %for.body
  %v = getelementptr inbounds %struct.Val, ptr %args.addr.0, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %2 = load ptr, ptr %car, align 8, !tbaa !46
  %v8 = getelementptr inbounds %struct.Val, ptr %vals.addr.0, i32 0, i32 1
  %p9 = getelementptr inbounds %struct.anon, ptr %v8, i32 0, i32 4
  %car10 = getelementptr inbounds %struct.anon.3, ptr %p9, i32 0, i32 0
  %3 = load ptr, ptr %car10, align 8, !tbaa !46
  br label %if.end12

if.else11:                                        ; preds = %for.body
  br label %if.end12

if.end12:                                         ; preds = %if.else11, %if.then7
  %val.0 = phi ptr [ %3, %if.then7 ], [ %vals.addr.0, %if.else11 ]
  %arg.0 = phi ptr [ %2, %if.then7 ], [ %args.addr.0, %if.else11 ]
  %t13 = getelementptr inbounds %struct.Val, ptr %arg.0, i32 0, i32 0
  %4 = load i32, ptr %t13, align 8, !tbaa !6
  %cmp14 = icmp ne i32 %4, 64
  br i1 %cmp14, label %if.then16, label %if.end20

if.then16:                                        ; preds = %if.end12
  br label %do.body

do.body:                                          ; preds = %if.then16
  %5 = load ptr, ptr @stderr, align 8, !tbaa !24
  %t17 = getelementptr inbounds %struct.Val, ptr %arg.0, i32 0, i32 0
  %6 = load i32, ptr %t17, align 8, !tbaa !6
  %call18 = call ptr @tsp_type_str(i32 noundef %6)
  %call19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.129, ptr noundef %call18)
  br label %cleanup

do.cond:                                          ; No predecessors!
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %if.end20

if.end20:                                         ; preds = %do.end, %if.end12
  %v21 = getelementptr inbounds %struct.Val, ptr %arg.0, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v21, i32 0, i32 0
  %7 = load ptr, ptr %s, align 8, !tbaa !29
  call void @rec_add(ptr noundef %call1, ptr noundef %7, ptr noundef %val.0)
  %t22 = getelementptr inbounds %struct.Val, ptr %args.addr.0, i32 0, i32 0
  %8 = load i32, ptr %t22, align 8, !tbaa !6
  %cmp23 = icmp ne i32 %8, 2048
  br i1 %cmp23, label %if.then25, label %if.end26

if.then25:                                        ; preds = %if.end20
  br label %for.end

if.end26:                                         ; preds = %if.end20
  br label %for.inc

for.inc:                                          ; preds = %if.end26
  %v27 = getelementptr inbounds %struct.Val, ptr %args.addr.0, i32 0, i32 1
  %p28 = getelementptr inbounds %struct.anon, ptr %v27, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p28, i32 0, i32 1
  %9 = load ptr, ptr %cdr, align 8, !tbaa !16
  %v29 = getelementptr inbounds %struct.Val, ptr %vals.addr.0, i32 0, i32 1
  %p30 = getelementptr inbounds %struct.anon, ptr %v29, i32 0, i32 4
  %cdr31 = getelementptr inbounds %struct.anon.3, ptr %p30, i32 0, i32 1
  %10 = load ptr, ptr %cdr31, align 8, !tbaa !16
  br label %for.cond, !llvm.loop !69

for.end:                                          ; preds = %if.then25, %for.cond
  br label %cleanup

cleanup:                                          ; preds = %for.end, %do.body
  %retval.0 = phi ptr [ null, %do.body ], [ %call1, %for.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local void @tisp_print(ptr noundef %f, ptr noundef %v) #0 {
entry:
  %t = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 0
  %0 = load i32, ptr %t, align 8, !tbaa !6
  switch i32 %0, label %sw.default [
    i32 1, label %sw.bb
    i32 2, label %sw.bb1
    i32 4, label %sw.bb3
    i32 8, label %sw.bb6
    i32 16, label %sw.bb21
    i32 32, label %sw.bb30
    i32 64, label %sw.bb30
    i32 512, label %sw.bb33
    i32 1024, label %sw.bb33
    i32 128, label %sw.bb48
    i32 256, label %sw.bb52
    i32 4096, label %sw.bb57
    i32 2048, label %sw.bb90
  ]

sw.bb:                                            ; preds = %entry
  %call = call i32 @fputs(ptr noundef @.str, ptr noundef %f)
  br label %sw.epilog

sw.bb1:                                           ; preds = %entry
  %call2 = call i32 @fputs(ptr noundef @.str.1, ptr noundef %f)
  br label %sw.epilog

sw.bb3:                                           ; preds = %entry
  %v4 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n = getelementptr inbounds %struct.anon, ptr %v4, i32 0, i32 1
  %num = getelementptr inbounds %struct.anon.0, ptr %n, i32 0, i32 0
  %1 = load double, ptr %num, align 8, !tbaa !20
  %conv = fptosi double %1 to i32
  %call5 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.44, i32 noundef %conv)
  br label %sw.epilog

sw.bb6:                                           ; preds = %entry
  %v7 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n8 = getelementptr inbounds %struct.anon, ptr %v7, i32 0, i32 1
  %num9 = getelementptr inbounds %struct.anon.0, ptr %n8, i32 0, i32 0
  %2 = load double, ptr %num9, align 8, !tbaa !20
  %call10 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.45, double noundef %2)
  %v11 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n12 = getelementptr inbounds %struct.anon, ptr %v11, i32 0, i32 1
  %num13 = getelementptr inbounds %struct.anon.0, ptr %n12, i32 0, i32 0
  %3 = load double, ptr %num13, align 8, !tbaa !20
  %v14 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n15 = getelementptr inbounds %struct.anon, ptr %v14, i32 0, i32 1
  %num16 = getelementptr inbounds %struct.anon.0, ptr %n15, i32 0, i32 0
  %4 = load double, ptr %num16, align 8, !tbaa !20
  %conv17 = fptosi double %4 to i32
  %conv18 = sitofp i32 %conv17 to double
  %cmp = fcmp oeq double %3, %conv18
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %sw.bb6
  %call20 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.46)
  br label %if.end

if.end:                                           ; preds = %if.then, %sw.bb6
  br label %sw.epilog

sw.bb21:                                          ; preds = %entry
  %v22 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n23 = getelementptr inbounds %struct.anon, ptr %v22, i32 0, i32 1
  %num24 = getelementptr inbounds %struct.anon.0, ptr %n23, i32 0, i32 0
  %5 = load double, ptr %num24, align 8, !tbaa !20
  %conv25 = fptosi double %5 to i32
  %v26 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %n27 = getelementptr inbounds %struct.anon, ptr %v26, i32 0, i32 1
  %den = getelementptr inbounds %struct.anon.0, ptr %n27, i32 0, i32 1
  %6 = load double, ptr %den, align 8, !tbaa !21
  %conv28 = fptosi double %6 to i32
  %call29 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.47, i32 noundef %conv25, i32 noundef %conv28)
  br label %sw.epilog

sw.bb30:                                          ; preds = %entry, %entry
  %v31 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v31, i32 0, i32 0
  %7 = load ptr, ptr %s, align 8, !tbaa !29
  %call32 = call i32 @fputs(ptr noundef %7, ptr noundef %f)
  br label %sw.epilog

sw.bb33:                                          ; preds = %entry, %entry
  %t34 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 0
  %8 = load i32, ptr %t34, align 8, !tbaa !6
  %cmp35 = icmp eq i32 %8, 512
  br i1 %cmp35, label %if.then37, label %if.else

if.then37:                                        ; preds = %sw.bb33
  br label %if.end38

if.else:                                          ; preds = %sw.bb33
  br label %if.end38

if.end38:                                         ; preds = %if.else, %if.then37
  %tmp1.0 = phi ptr [ @.str.48, %if.then37 ], [ @.str.49, %if.else ]
  %v39 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %f40 = getelementptr inbounds %struct.anon, ptr %v39, i32 0, i32 3
  %name = getelementptr inbounds %struct.anon.2, ptr %f40, i32 0, i32 0
  %9 = load ptr, ptr %name, align 8, !tbaa !41
  %tobool = icmp ne ptr %9, null
  br i1 %tobool, label %if.then41, label %if.else45

if.then41:                                        ; preds = %if.end38
  %v42 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %f43 = getelementptr inbounds %struct.anon, ptr %v42, i32 0, i32 3
  %name44 = getelementptr inbounds %struct.anon.2, ptr %f43, i32 0, i32 0
  %10 = load ptr, ptr %name44, align 8, !tbaa !41
  br label %if.end46

if.else45:                                        ; preds = %if.end38
  br label %if.end46

if.end46:                                         ; preds = %if.else45, %if.then41
  %tmp3.0 = phi ptr [ %10, %if.then41 ], [ @.str.42, %if.else45 ]
  %tmp2.0 = phi ptr [ @.str.50, %if.then41 ], [ @.str.42, %if.else45 ]
  %call47 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.51, ptr noundef %tmp1.0, ptr noundef %tmp2.0, ptr noundef %tmp3.0)
  br label %sw.epilog

sw.bb48:                                          ; preds = %entry
  %v49 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %pr = getelementptr inbounds %struct.anon, ptr %v49, i32 0, i32 2
  %name50 = getelementptr inbounds %struct.anon.1, ptr %pr, i32 0, i32 0
  %11 = load ptr, ptr %name50, align 8, !tbaa !39
  %call51 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.52, ptr noundef %11)
  br label %sw.epilog

sw.bb52:                                          ; preds = %entry
  %v53 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %pr54 = getelementptr inbounds %struct.anon, ptr %v53, i32 0, i32 2
  %name55 = getelementptr inbounds %struct.anon.1, ptr %pr54, i32 0, i32 0
  %12 = load ptr, ptr %name55, align 8, !tbaa !39
  %call56 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.53, ptr noundef %12)
  br label %sw.epilog

sw.bb57:                                          ; preds = %entry
  %call58 = call i32 @putc(i32 noundef 123, ptr noundef %f)
  %v59 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %r60 = getelementptr inbounds %struct.anon, ptr %v59, i32 0, i32 5
  %13 = load ptr, ptr %r60, align 8, !tbaa !45
  br label %for.cond

for.cond:                                         ; preds = %for.inc86, %sw.bb57
  %r.0 = phi ptr [ %13, %sw.bb57 ], [ %21, %for.inc86 ]
  %tobool61 = icmp ne ptr %r.0, null
  br i1 %tobool61, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end88

for.body:                                         ; preds = %for.cond
  br label %for.cond62

for.cond62:                                       ; preds = %for.inc, %for.body
  %i.0 = phi i32 [ 0, %for.body ], [ %inc84, %for.inc ]
  %c.0 = phi i32 [ 0, %for.body ], [ %c.1, %for.inc ]
  %size = getelementptr inbounds %struct.Rec, ptr %r.0, i32 0, i32 0
  %14 = load i32, ptr %size, align 8, !tbaa !36
  %cmp63 = icmp slt i32 %c.0, %14
  br i1 %cmp63, label %for.body66, label %for.cond.cleanup65

for.cond.cleanup65:                               ; preds = %for.cond62
  br label %cleanup

for.body66:                                       ; preds = %for.cond62
  %items = getelementptr inbounds %struct.Rec, ptr %r.0, i32 0, i32 2
  %15 = load ptr, ptr %items, align 8, !tbaa !48
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds %struct.Entry, ptr %15, i64 %idxprom
  %key = getelementptr inbounds %struct.Entry, ptr %arrayidx, i32 0, i32 0
  %16 = load ptr, ptr %key, align 8, !tbaa !30
  %tobool67 = icmp ne ptr %16, null
  br i1 %tobool67, label %if.then68, label %if.else77

if.then68:                                        ; preds = %for.body66
  %inc = add nsw i32 %c.0, 1
  %items69 = getelementptr inbounds %struct.Rec, ptr %r.0, i32 0, i32 2
  %17 = load ptr, ptr %items69, align 8, !tbaa !48
  %idxprom70 = sext i32 %i.0 to i64
  %arrayidx71 = getelementptr inbounds %struct.Entry, ptr %17, i64 %idxprom70
  %key72 = getelementptr inbounds %struct.Entry, ptr %arrayidx71, i32 0, i32 0
  %18 = load ptr, ptr %key72, align 8, !tbaa !30
  %call73 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %f, ptr noundef @.str.54, ptr noundef %18)
  %items74 = getelementptr inbounds %struct.Rec, ptr %r.0, i32 0, i32 2
  %19 = load ptr, ptr %items74, align 8, !tbaa !48
  %idxprom75 = sext i32 %i.0 to i64
  %arrayidx76 = getelementptr inbounds %struct.Entry, ptr %19, i64 %idxprom75
  %val = getelementptr inbounds %struct.Entry, ptr %arrayidx76, i32 0, i32 1
  %20 = load ptr, ptr %val, align 8, !tbaa !32
  call void @tisp_print(ptr noundef %f, ptr noundef %20)
  br label %if.end83

if.else77:                                        ; preds = %for.body66
  %cmp78 = icmp eq i32 %c.0, 64
  br i1 %cmp78, label %if.then80, label %if.end82

if.then80:                                        ; preds = %if.else77
  %call81 = call i32 @fputs(ptr noundef @.str.55, ptr noundef %f)
  br label %cleanup

if.end82:                                         ; preds = %if.else77
  br label %if.end83

if.end83:                                         ; preds = %if.end82, %if.then68
  %c.1 = phi i32 [ %inc, %if.then68 ], [ %c.0, %if.end82 ]
  br label %for.inc

for.inc:                                          ; preds = %if.end83
  %inc84 = add nsw i32 %i.0, 1
  br label %for.cond62, !llvm.loop !70

cleanup:                                          ; preds = %if.then80, %for.cond.cleanup65
  br label %for.end

for.end:                                          ; preds = %cleanup
  br label %for.inc86

for.inc86:                                        ; preds = %for.end
  %next = getelementptr inbounds %struct.Rec, ptr %r.0, i32 0, i32 3
  %21 = load ptr, ptr %next, align 8, !tbaa !33
  br label %for.cond, !llvm.loop !71

for.end88:                                        ; preds = %for.cond.cleanup
  %call89 = call i32 @fputs(ptr noundef @.str.56, ptr noundef %f)
  br label %sw.epilog

sw.bb90:                                          ; preds = %entry
  %call91 = call i32 @putc(i32 noundef 40, ptr noundef %f)
  %v92 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v92, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %22 = load ptr, ptr %car, align 8, !tbaa !46
  call void @tisp_print(ptr noundef %f, ptr noundef %22)
  %v93 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 1
  %p94 = getelementptr inbounds %struct.anon, ptr %v93, i32 0, i32 4
  %cdr = getelementptr inbounds %struct.anon.3, ptr %p94, i32 0, i32 1
  %23 = load ptr, ptr %cdr, align 8, !tbaa !16
  br label %for.cond95

for.cond95:                                       ; preds = %for.inc111, %sw.bb90
  %v.addr.0 = phi ptr [ %23, %sw.bb90 ], [ %27, %for.inc111 ]
  %t96 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %24 = load i32, ptr %t96, align 8, !tbaa !6
  %cmp97 = icmp eq i32 %24, 2
  %lnot = xor i1 %cmp97, true
  br i1 %lnot, label %for.body99, label %for.end115

for.body99:                                       ; preds = %for.cond95
  %t100 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 0
  %25 = load i32, ptr %t100, align 8, !tbaa !6
  %cmp101 = icmp eq i32 %25, 2048
  br i1 %cmp101, label %if.then103, label %if.else108

if.then103:                                       ; preds = %for.body99
  %call104 = call i32 @putc(i32 noundef 32, ptr noundef %f)
  %v105 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p106 = getelementptr inbounds %struct.anon, ptr %v105, i32 0, i32 4
  %car107 = getelementptr inbounds %struct.anon.3, ptr %p106, i32 0, i32 0
  %26 = load ptr, ptr %car107, align 8, !tbaa !46
  call void @tisp_print(ptr noundef %f, ptr noundef %26)
  br label %if.end110

if.else108:                                       ; preds = %for.body99
  %call109 = call i32 @fputs(ptr noundef @.str.57, ptr noundef %f)
  call void @tisp_print(ptr noundef %f, ptr noundef %v.addr.0)
  br label %for.end115

if.end110:                                        ; preds = %if.then103
  br label %for.inc111

for.inc111:                                       ; preds = %if.end110
  %v112 = getelementptr inbounds %struct.Val, ptr %v.addr.0, i32 0, i32 1
  %p113 = getelementptr inbounds %struct.anon, ptr %v112, i32 0, i32 4
  %cdr114 = getelementptr inbounds %struct.anon.3, ptr %p113, i32 0, i32 1
  %27 = load ptr, ptr %cdr114, align 8, !tbaa !16
  br label %for.cond95, !llvm.loop !72

for.end115:                                       ; preds = %if.else108, %for.cond95
  %call116 = call i32 @putc(i32 noundef 41, ptr noundef %f)
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  %28 = load ptr, ptr @stderr, align 8, !tbaa !24
  %t117 = getelementptr inbounds %struct.Val, ptr %v, i32 0, i32 0
  %29 = load i32, ptr %t117, align 8, !tbaa !6
  %call118 = call ptr @tsp_type_str(i32 noundef %29)
  %call119 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %28, ptr noundef @.str.58, ptr noundef %call118)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %for.end115, %for.end88, %sw.bb52, %sw.bb48, %if.end46, %sw.bb30, %sw.bb21, %if.end, %sw.bb3, %sw.bb1, %sw.bb
  ret void
}

declare i32 @fputs(ptr noundef, ptr noundef) #5

declare i32 @putc(i32 noundef, ptr noundef) #5

; Function Attrs: nounwind uwtable
define dso_local void @tisp_env_add(ptr noundef %st, ptr noundef %key, ptr noundef %v) #0 {
entry:
  %env = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 5
  %0 = load ptr, ptr %env, align 8, !tbaa !73
  call void @rec_add(ptr noundef %0, ptr noundef %key, ptr noundef %v)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @tisp_env_init(i64 noundef %cap) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 80) #11
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @perror(ptr noundef @.str.17) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end:                                           ; preds = %entry
  %file = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 0
  store ptr null, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 1
  store i64 0, ptr %filec, align 8, !tbaa !52
  %call1 = call ptr @rec_new(i64 noundef %cap, ptr noundef null)
  %strs = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 6
  store ptr %call1, ptr %strs, align 8, !tbaa !26
  %call2 = call ptr @rec_new(i64 noundef %cap, ptr noundef null)
  %syms = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 7
  store ptr %call2, ptr %syms, align 8, !tbaa !38
  %call3 = call ptr @mk_val(i32 noundef 2)
  %nil = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 3
  store ptr %call3, ptr %nil, align 8, !tbaa !49
  %call4 = call ptr @mk_val(i32 noundef 1)
  %none = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 2
  store ptr %call4, ptr %none, align 8, !tbaa !58
  %call5 = call ptr @mk_val(i32 noundef 64)
  %t = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 4
  store ptr %call5, ptr %t, align 8, !tbaa !74
  %t6 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 4
  %0 = load ptr, ptr %t6, align 8, !tbaa !74
  %v = getelementptr inbounds %struct.Val, ptr %0, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 0
  store ptr @.str.59, ptr %s, align 8, !tbaa !29
  %call7 = call ptr @rec_new(i64 noundef %cap, ptr noundef null)
  %env = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 5
  store ptr %call7, ptr %env, align 8, !tbaa !73
  %t8 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 4
  %1 = load ptr, ptr %t8, align 8, !tbaa !74
  call void @tisp_env_add(ptr noundef %call, ptr noundef @.str.59, ptr noundef %1)
  %nil9 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 3
  %2 = load ptr, ptr %nil9, align 8, !tbaa !49
  call void @tisp_env_add(ptr noundef %call, ptr noundef @.str.1, ptr noundef %2)
  %none10 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 2
  %3 = load ptr, ptr %none10, align 8, !tbaa !58
  call void @tisp_env_add(ptr noundef %call, ptr noundef @.str, ptr noundef %3)
  %nil11 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 3
  %4 = load ptr, ptr %nil11, align 8, !tbaa !49
  call void @tisp_env_add(ptr noundef %call, ptr noundef @.str.60, ptr noundef %4)
  %call12 = call ptr @mk_str(ptr noundef %call, ptr noundef @.str.62)
  call void @tisp_env_add(ptr noundef %call, ptr noundef @.str.61, ptr noundef %call12)
  %libh = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 8
  store ptr null, ptr %libh, align 8, !tbaa !75
  %libhc = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 9
  store i64 0, ptr %libhc, align 8, !tbaa !76
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local void @tisp_env_lib(ptr noundef %st, ptr noundef %lib) #0 {
entry:
  %file1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file1, align 8, !tbaa !51
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec2, align 8, !tbaa !52
  %file3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  store ptr %lib, ptr %file3, align 8, !tbaa !51
  %filec4 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  store i64 0, ptr %filec4, align 8, !tbaa !52
  call void @skip_ws(ptr noundef %st, i32 noundef 1)
  %call = call ptr @tisp_read(ptr noundef %st)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %env = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 5
  %2 = load ptr, ptr %env, align 8, !tbaa !73
  %call5 = call ptr @tisp_eval_body(ptr noundef %st, ptr noundef %2, ptr noundef %call)
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %file6 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  store ptr %0, ptr %file6, align 8, !tbaa !51
  %filec7 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  store i64 %1, ptr %filec7, align 8, !tbaa !52
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @tib_env_core(ptr noundef %st) #0 {
entry:
  %0 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call = call ptr @mk_prim(i32 noundef 128, ptr noundef %0, ptr noundef @.str.63)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.63, ptr noundef %call)
  %1 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call1 = call ptr @mk_prim(i32 noundef 128, ptr noundef %1, ptr noundef @.str.64)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.64, ptr noundef %call1)
  %2 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call2 = call ptr @mk_prim(i32 noundef 128, ptr noundef %2, ptr noundef @.str.65)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.65, ptr noundef %call2)
  %3 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call3 = call ptr @mk_prim(i32 noundef 256, ptr noundef %3, ptr noundef @.str.24)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.24, ptr noundef %call3)
  %4 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call4 = call ptr @mk_prim(i32 noundef 128, ptr noundef %4, ptr noundef @.str.66)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.66, ptr noundef %call4)
  %5 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call5 = call ptr @mk_prim(i32 noundef 128, ptr noundef %5, ptr noundef @.str.67)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.67, ptr noundef %call5)
  %6 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call6 = call ptr @mk_prim(i32 noundef 256, ptr noundef %6, ptr noundef @.str.68)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.68, ptr noundef %call6)
  %7 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call7 = call ptr @mk_prim(i32 noundef 256, ptr noundef %7, ptr noundef @.str.69)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.69, ptr noundef %call7)
  %8 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call8 = call ptr @mk_prim(i32 noundef 128, ptr noundef %8, ptr noundef @.str.70)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.70, ptr noundef %call8)
  %9 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call9 = call ptr @mk_prim(i32 noundef 128, ptr noundef %9, ptr noundef @.str.71)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.71, ptr noundef %call9)
  %10 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call10 = call ptr @mk_prim(i32 noundef 256, ptr noundef %10, ptr noundef @.str.9)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.9, ptr noundef %call10)
  %11 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call11 = call ptr @mk_prim(i32 noundef 256, ptr noundef %11, ptr noundef @.str.10)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.10, ptr noundef %call11)
  %12 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call12 = call ptr @mk_prim(i32 noundef 128, ptr noundef %12, ptr noundef @.str.72)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.72, ptr noundef %call12)
  %13 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call13 = call ptr @mk_prim(i32 noundef 256, ptr noundef %13, ptr noundef @.str.12)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.12, ptr noundef %call13)
  %14 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call14 = call ptr @mk_prim(i32 noundef 128, ptr noundef %14, ptr noundef @.str.36)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.36, ptr noundef %call14)
  %15 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call15 = call ptr @mk_prim(i32 noundef 128, ptr noundef %15, ptr noundef @.str.73)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.73, ptr noundef %call15)
  %16 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call16 = call ptr @mk_prim(i32 noundef 256, ptr noundef %16, ptr noundef @.str.74)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.74, ptr noundef %call16)
  %17 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call17 = call ptr @mk_prim(i32 noundef 256, ptr noundef %17, ptr noundef @.str.75)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.75, ptr noundef %call17)
  %18 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call18 = call ptr @mk_prim(i32 noundef 256, ptr noundef %18, ptr noundef @.str.76)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.76, ptr noundef %call18)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @tib_env_string(ptr noundef %st) #0 {
entry:
  %0 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call = call ptr @mk_prim(i32 noundef 128, ptr noundef %0, ptr noundef @.str.6)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.6, ptr noundef %call)
  %1 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call1 = call ptr @mk_prim(i32 noundef 128, ptr noundef %1, ptr noundef @.str.5)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.5, ptr noundef %call1)
  %2 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call2 = call ptr @mk_prim(i32 noundef 128, ptr noundef %2, ptr noundef @.str.77)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.77, ptr noundef %call2)
  %3 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call3 = call ptr @mk_prim(i32 noundef 256, ptr noundef %3, ptr noundef @.str.33)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.33, ptr noundef %call3)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @tib_env_math(ptr noundef %st) #0 {
entry:
  %0 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call = call ptr @mk_prim(i32 noundef 128, ptr noundef %0, ptr noundef @.str.2)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.2, ptr noundef %call)
  %1 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call1 = call ptr @mk_prim(i32 noundef 128, ptr noundef %1, ptr noundef @.str.3)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.3, ptr noundef %call1)
  %2 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call2 = call ptr @mk_prim(i32 noundef 128, ptr noundef %2, ptr noundef @.str.78)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.78, ptr noundef %call2)
  %3 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call3 = call ptr @mk_prim(i32 noundef 128, ptr noundef %3, ptr noundef @.str.79)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.79, ptr noundef %call3)
  %4 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call4 = call ptr @mk_prim(i32 noundef 128, ptr noundef %4, ptr noundef @.str.80)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.80, ptr noundef %call4)
  %5 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call5 = call ptr @mk_prim(i32 noundef 128, ptr noundef %5, ptr noundef @.str.81)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.81, ptr noundef %call5)
  %6 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call6 = call ptr @mk_prim(i32 noundef 128, ptr noundef %6, ptr noundef @.str.82)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.82, ptr noundef %call6)
  %7 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call7 = call ptr @mk_prim(i32 noundef 128, ptr noundef %7, ptr noundef @.str.83)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.83, ptr noundef %call7)
  %8 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call8 = call ptr @mk_prim(i32 noundef 128, ptr noundef %8, ptr noundef @.str.84)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.84, ptr noundef %call8)
  %9 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call9 = call ptr @mk_prim(i32 noundef 128, ptr noundef %9, ptr noundef @.str.85)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.85, ptr noundef %call9)
  %10 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call10 = call ptr @mk_prim(i32 noundef 128, ptr noundef %10, ptr noundef @.str.86)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.86, ptr noundef %call10)
  %11 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call11 = call ptr @mk_prim(i32 noundef 128, ptr noundef %11, ptr noundef @.str.87)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.87, ptr noundef %call11)
  %12 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call12 = call ptr @mk_prim(i32 noundef 128, ptr noundef %12, ptr noundef @.str.88)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.88, ptr noundef %call12)
  %13 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call13 = call ptr @mk_prim(i32 noundef 128, ptr noundef %13, ptr noundef @.str.89)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.89, ptr noundef %call13)
  %14 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call14 = call ptr @mk_prim(i32 noundef 128, ptr noundef %14, ptr noundef @.str.90)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.90, ptr noundef %call14)
  %15 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call15 = call ptr @mk_prim(i32 noundef 128, ptr noundef %15, ptr noundef @.str.91)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.91, ptr noundef %call15)
  %16 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call16 = call ptr @mk_prim(i32 noundef 128, ptr noundef %16, ptr noundef @.str.92)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.92, ptr noundef %call16)
  %17 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call17 = call ptr @mk_prim(i32 noundef 128, ptr noundef %17, ptr noundef @.str.93)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.93, ptr noundef %call17)
  %18 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call18 = call ptr @mk_prim(i32 noundef 128, ptr noundef %18, ptr noundef @.str.94)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.94, ptr noundef %call18)
  %19 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call19 = call ptr @mk_prim(i32 noundef 128, ptr noundef %19, ptr noundef @.str.95)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.95, ptr noundef %call19)
  %20 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call20 = call ptr @mk_prim(i32 noundef 128, ptr noundef %20, ptr noundef @.str.96)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.96, ptr noundef %call20)
  %21 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call21 = call ptr @mk_prim(i32 noundef 128, ptr noundef %21, ptr noundef @.str.97)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.97, ptr noundef %call21)
  %22 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call22 = call ptr @mk_prim(i32 noundef 128, ptr noundef %22, ptr noundef @.str.98)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.98, ptr noundef %call22)
  %23 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call23 = call ptr @mk_prim(i32 noundef 128, ptr noundef %23, ptr noundef @.str.99)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.99, ptr noundef %call23)
  %24 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call24 = call ptr @mk_prim(i32 noundef 128, ptr noundef %24, ptr noundef @.str.100)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.100, ptr noundef %call24)
  %25 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call25 = call ptr @mk_prim(i32 noundef 128, ptr noundef %25, ptr noundef @.str.101)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.101, ptr noundef %call25)
  %26 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call26 = call ptr @mk_prim(i32 noundef 128, ptr noundef %26, ptr noundef @.str.102)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.102, ptr noundef %call26)
  %27 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call27 = call ptr @mk_prim(i32 noundef 128, ptr noundef %27, ptr noundef @.str.103)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.103, ptr noundef %call27)
  %28 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call28 = call ptr @mk_prim(i32 noundef 128, ptr noundef %28, ptr noundef @.str.104)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.104, ptr noundef %call28)
  %29 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call29 = call ptr @mk_prim(i32 noundef 128, ptr noundef %29, ptr noundef @.str.105)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.105, ptr noundef %call29)
  %30 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call30 = call ptr @mk_prim(i32 noundef 128, ptr noundef %30, ptr noundef @.str.106)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.106, ptr noundef %call30)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @tib_env_io(ptr noundef %st) #0 {
entry:
  %0 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call = call ptr @mk_prim(i32 noundef 128, ptr noundef %0, ptr noundef @.str.107)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.107, ptr noundef %call)
  %1 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call1 = call ptr @mk_prim(i32 noundef 128, ptr noundef %1, ptr noundef @.str.108)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.108, ptr noundef %call1)
  %2 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call2 = call ptr @mk_prim(i32 noundef 128, ptr noundef %2, ptr noundef @.str.109)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.109, ptr noundef %call2)
  %3 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call3 = call ptr @mk_prim(i32 noundef 128, ptr noundef %3, ptr noundef @.str.110)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.110, ptr noundef %call3)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @tib_env_os(ptr noundef %st) #0 {
entry:
  %0 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call = call ptr @mk_prim(i32 noundef 128, ptr noundef %0, ptr noundef @.str.111)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.111, ptr noundef %call)
  %1 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call1 = call ptr @mk_prim(i32 noundef 128, ptr noundef %1, ptr noundef @.str.112)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.112, ptr noundef %call1)
  %2 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call2 = call ptr @mk_prim(i32 noundef 128, ptr noundef %2, ptr noundef @.str.113)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.113, ptr noundef %call2)
  %3 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call3 = call ptr @mk_prim(i32 noundef 128, ptr noundef %3, ptr noundef @.str.114)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.114, ptr noundef %call3)
  %4 = load ptr, ptr @global_prim_val, align 8, !tbaa !24
  %call4 = call ptr @mk_prim(i32 noundef 256, ptr noundef %4, ptr noundef @.str.115)
  call void @tisp_env_add(ptr noundef %st, ptr noundef @.str.115, ptr noundef %call4)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @read_parse_eval(ptr noundef %st, ptr noundef %file) #0 {
entry:
  %call = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.109)
  %call1 = call ptr @mk_sym(ptr noundef %st, ptr noundef @.str.108)
  %call2 = call ptr @mk_pair(ptr noundef %call1, ptr noundef %file)
  %call3 = call ptr (ptr, i32, ...) @mk_list(ptr noundef %st, i32 noundef 2, ptr noundef %call, ptr noundef %call2)
  %env = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 5
  %0 = load ptr, ptr %env, align 8, !tbaa !73
  %call4 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %0, ptr noundef %call3)
  %env5 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 5
  %1 = load ptr, ptr %env5, align 8, !tbaa !73
  %call6 = call ptr @tisp_eval(ptr noundef %st, ptr noundef %1, ptr noundef %call4)
  ret ptr %call6
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %sigint = alloca %struct.sigaction, align 8
  %call = call ptr @tisp_env_init(i64 noundef 1024)
  call void @tib_env_core(ptr noundef %call)
  call void @tib_env_math(ptr noundef %call)
  call void @tib_env_io(ptr noundef %call)
  call void @tib_env_os(ptr noundef %call)
  call void @tib_env_string(ptr noundef %call)
  call void @tisp_env_lib(ptr noundef %call, ptr noundef @tibs)
  call void @llvm.lifetime.start.p0(i64 152, ptr %sigint) #16
  %__sigaction_handler = getelementptr inbounds %struct.sigaction, ptr %sigint, i32 0, i32 0
  store ptr inttoptr (i64 1 to ptr), ptr %__sigaction_handler, align 8, !tbaa !53
  %call1 = call i32 @sigaction(i32 noundef 2, ptr noundef %sigint, ptr noundef null) #16
  %cmp = icmp eq i32 %argc, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %file = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 0
  store ptr @.str.116, ptr %file, align 8, !tbaa !51
  br label %readstr

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %i.0 = phi i32 [ %inc82, %for.inc ], [ 1, %if.end ]
  %cmp2 = icmp slt i32 %i.0, %argc
  br i1 %cmp2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds ptr, ptr %argv, i64 %idxprom
  %0 = load ptr, ptr %arrayidx, align 8, !tbaa !24
  %arrayidx3 = getelementptr inbounds i8, ptr %0, i64 0
  %1 = load i8, ptr %arrayidx3, align 1, !tbaa !53
  %conv = zext i8 %1 to i32
  %cmp4 = icmp eq i32 %conv, 45
  br i1 %cmp4, label %if.then6, label %if.else69

if.then6:                                         ; preds = %for.body
  %idxprom7 = sext i32 %i.0 to i64
  %arrayidx8 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom7
  %2 = load ptr, ptr %arrayidx8, align 8, !tbaa !24
  %arrayidx9 = getelementptr inbounds i8, ptr %2, i64 1
  %3 = load i8, ptr %arrayidx9, align 1, !tbaa !53
  %conv10 = zext i8 %3 to i32
  %cmp11 = icmp eq i32 %conv10, 99
  br i1 %cmp11, label %if.then13, label %if.else

if.then13:                                        ; preds = %if.then6
  %inc = add nsw i32 %i.0, 1
  %idxprom14 = sext i32 %inc to i64
  %arrayidx15 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom14
  %4 = load ptr, ptr %arrayidx15, align 8, !tbaa !24
  %file16 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 0
  store ptr %4, ptr %file16, align 8, !tbaa !51
  %tobool = icmp ne ptr %4, null
  br i1 %tobool, label %if.end19, label %if.then17

if.then17:                                        ; preds = %if.then13
  %5 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call18 = call i32 @fputs(ptr noundef @.str.117, ptr noundef %5)
  call void @exit(i32 noundef 2) #13
  unreachable

if.end19:                                         ; preds = %if.then13
  br label %readstr

readstr:                                          ; preds = %if.end19, %if.then
  %i.1 = phi i32 [ 1, %if.then ], [ %inc, %if.end19 ]
  %call20 = call ptr @tisp_read(ptr noundef %call)
  %tobool21 = icmp ne ptr %call20, null
  br i1 %tobool21, label %if.then22, label %if.end24

if.then22:                                        ; preds = %readstr
  %env = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 5
  %6 = load ptr, ptr %env, align 8, !tbaa !73
  %call23 = call ptr @tisp_eval(ptr noundef %call, ptr noundef %6, ptr noundef %call20)
  br label %if.end24

if.end24:                                         ; preds = %if.then22, %readstr
  %v.0 = phi ptr [ %call23, %if.then22 ], [ %call20, %readstr ]
  br label %if.end68

if.else:                                          ; preds = %if.then6
  %idxprom25 = sext i32 %i.0 to i64
  %arrayidx26 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom25
  %7 = load ptr, ptr %arrayidx26, align 8, !tbaa !24
  %arrayidx27 = getelementptr inbounds i8, ptr %7, i64 1
  %8 = load i8, ptr %arrayidx27, align 1, !tbaa !53
  %conv28 = zext i8 %8 to i32
  %cmp29 = icmp eq i32 %conv28, 114
  br i1 %cmp29, label %if.then31, label %if.else39

if.then31:                                        ; preds = %if.else
  %file32 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 0
  store ptr @.str.116, ptr %file32, align 8, !tbaa !51
  %call33 = call ptr @tisp_read(ptr noundef %call)
  %tobool34 = icmp ne ptr %call33, null
  br i1 %tobool34, label %if.then35, label %if.end38

if.then35:                                        ; preds = %if.then31
  %env36 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 5
  %9 = load ptr, ptr %env36, align 8, !tbaa !73
  %call37 = call ptr @tisp_eval(ptr noundef %call, ptr noundef %9, ptr noundef %call33)
  br label %if.end38

if.end38:                                         ; preds = %if.then35, %if.then31
  %v.1 = phi ptr [ %call37, %if.then35 ], [ %call33, %if.then31 ]
  br label %if.end67

if.else39:                                        ; preds = %if.else
  %idxprom40 = sext i32 %i.0 to i64
  %arrayidx41 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom40
  %10 = load ptr, ptr %arrayidx41, align 8, !tbaa !24
  %arrayidx42 = getelementptr inbounds i8, ptr %10, i64 1
  %11 = load i8, ptr %arrayidx42, align 1, !tbaa !53
  %conv43 = zext i8 %11 to i32
  %cmp44 = icmp eq i32 %conv43, 118
  br i1 %cmp44, label %if.then46, label %if.else48

if.then46:                                        ; preds = %if.else39
  %12 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call47 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %12, ptr noundef @.str.118, ptr noundef @.str.119)
  call void @exit(i32 noundef 0) #13
  unreachable

if.else48:                                        ; preds = %if.else39
  %idxprom49 = sext i32 %i.0 to i64
  %arrayidx50 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom49
  %13 = load ptr, ptr %arrayidx50, align 8, !tbaa !24
  %arrayidx51 = getelementptr inbounds i8, ptr %13, i64 1
  %14 = load i8, ptr %arrayidx51, align 1, !tbaa !53
  %tobool52 = icmp ne i8 %14, 0
  br i1 %tobool52, label %if.then53, label %if.else63

if.then53:                                        ; preds = %if.else48
  %15 = load ptr, ptr @stderr, align 8, !tbaa !24
  %call54 = call i32 @fputs(ptr noundef @.str.120, ptr noundef %15)
  %idxprom55 = sext i32 %i.0 to i64
  %arrayidx56 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom55
  %16 = load ptr, ptr %arrayidx56, align 8, !tbaa !24
  %arrayidx57 = getelementptr inbounds i8, ptr %16, i64 1
  %17 = load i8, ptr %arrayidx57, align 1, !tbaa !53
  %conv58 = zext i8 %17 to i32
  %cmp59 = icmp eq i32 %conv58, 104
  br i1 %cmp59, label %if.then61, label %if.else62

if.then61:                                        ; preds = %if.then53
  call void @exit(i32 noundef 0) #13
  unreachable

if.else62:                                        ; preds = %if.then53
  call void @exit(i32 noundef 1) #13
  unreachable

if.else63:                                        ; preds = %if.else48
  %nil = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 3
  %18 = load ptr, ptr %nil, align 8, !tbaa !49
  %call64 = call ptr @read_parse_eval(ptr noundef %call, ptr noundef %18)
  br label %if.end65

if.end65:                                         ; preds = %if.else63
  br label %if.end66

if.end66:                                         ; preds = %if.end65
  br label %if.end67

if.end67:                                         ; preds = %if.end66, %if.end38
  %v.2 = phi ptr [ %v.1, %if.end38 ], [ %call64, %if.end66 ]
  br label %if.end68

if.end68:                                         ; preds = %if.end67, %if.end24
  %i.2 = phi i32 [ %i.1, %if.end24 ], [ %i.0, %if.end67 ]
  %v.3 = phi ptr [ %v.0, %if.end24 ], [ %v.2, %if.end67 ]
  br label %if.end76

if.else69:                                        ; preds = %for.body
  %idxprom70 = sext i32 %i.0 to i64
  %arrayidx71 = getelementptr inbounds ptr, ptr %argv, i64 %idxprom70
  %19 = load ptr, ptr %arrayidx71, align 8, !tbaa !24
  %call72 = call ptr @mk_str(ptr noundef %call, ptr noundef %19)
  %nil73 = getelementptr inbounds %struct.Tsp, ptr %call, i32 0, i32 3
  %20 = load ptr, ptr %nil73, align 8, !tbaa !49
  %call74 = call ptr @mk_pair(ptr noundef %call72, ptr noundef %20)
  %call75 = call ptr @read_parse_eval(ptr noundef %call, ptr noundef %call74)
  br label %if.end76

if.end76:                                         ; preds = %if.else69, %if.end68
  %i.3 = phi i32 [ %i.2, %if.end68 ], [ %i.0, %if.else69 ]
  %v.4 = phi ptr [ %v.3, %if.end68 ], [ %call75, %if.else69 ]
  %tobool77 = icmp ne ptr %v.4, null
  br i1 %tobool77, label %land.lhs.true, label %if.end81

land.lhs.true:                                    ; preds = %if.end76
  %t = getelementptr inbounds %struct.Val, ptr %v.4, i32 0, i32 0
  %21 = load i32, ptr %t, align 8, !tbaa !6
  %cmp78 = icmp ne i32 %21, 1
  br i1 %cmp78, label %if.then80, label %if.end81

if.then80:                                        ; preds = %land.lhs.true
  %22 = load ptr, ptr @stdout, align 8, !tbaa !24
  call void @tisp_print(ptr noundef %22, ptr noundef %v.4)
  br label %if.end81

if.end81:                                         ; preds = %if.then80, %land.lhs.true, %if.end76
  br label %for.inc

for.inc:                                          ; preds = %if.end81
  %inc82 = add nsw i32 %i.3, 1
  br label %for.cond, !llvm.loop !77

for.end:                                          ; preds = %for.cond
  %call83 = call i32 @puts(ptr noundef @.str.42)
  call void @llvm.lifetime.end.p0(i64 152, ptr %sigint) #16
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @sigaction(i32 noundef, ptr noundef, ptr noundef) #9

declare i32 @puts(ptr noundef) #5

; Function Attrs: nounwind uwtable
define internal ptr @entry_get(ptr noundef %rec, ptr noundef %key) #0 {
entry:
  %call = call i32 @hash(ptr noundef %key)
  %cap = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %0 = load i32, ptr %cap, align 4, !tbaa !37
  %rem = urem i32 %call, %0
  br label %while.cond

while.cond:                                       ; preds = %if.end6, %entry
  %i.0 = phi i32 [ %rem, %entry ], [ %i.1, %if.end6 ]
  %items = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 2
  %1 = load ptr, ptr %items, align 8, !tbaa !48
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds %struct.Entry, ptr %1, i64 %idxprom
  %key1 = getelementptr inbounds %struct.Entry, ptr %arrayidx, i32 0, i32 0
  %2 = load ptr, ptr %key1, align 8, !tbaa !30
  %tobool = icmp ne ptr %2, null
  br i1 %tobool, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %call2 = call i32 @strcmp(ptr noundef %2, ptr noundef %key) #17
  %tobool3 = icmp ne i32 %call2, 0
  br i1 %tobool3, label %if.end, label %if.then

if.then:                                          ; preds = %while.body
  br label %while.end

if.end:                                           ; preds = %while.body
  %inc = add nsw i32 %i.0, 1
  %cap4 = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %3 = load i32, ptr %cap4, align 4, !tbaa !37
  %cmp = icmp eq i32 %inc, %3
  br i1 %cmp, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  br label %if.end6

if.end6:                                          ; preds = %if.then5, %if.end
  %i.1 = phi i32 [ 0, %if.then5 ], [ %inc, %if.end ]
  br label %while.cond, !llvm.loop !78

while.end:                                        ; preds = %if.then, %while.cond
  %items7 = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 2
  %4 = load ptr, ptr %items7, align 8, !tbaa !48
  %idxprom8 = sext i32 %i.0 to i64
  %arrayidx9 = getelementptr inbounds %struct.Entry, ptr %4, i64 %idxprom8
  ret ptr %arrayidx9
}

; Function Attrs: nounwind uwtable
define internal i32 @hash(ptr noundef %key) #0 {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %c.0 = phi i8 [ undef, %entry ], [ %c.1, %while.body ]
  %h.0 = phi i32 [ 0, %entry ], [ %add, %while.body ]
  %key.addr.0 = phi ptr [ %key, %entry ], [ %key.addr.1, %while.body ]
  %cmp = icmp ult i32 %h.0, -1
  br i1 %cmp, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %incdec.ptr = getelementptr inbounds i8, ptr %key.addr.0, i32 1
  %0 = load i8, ptr %key.addr.0, align 1, !tbaa !53
  %conv = zext i8 %0 to i32
  %tobool = icmp ne i32 %conv, 0
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %c.1 = phi i8 [ %0, %land.rhs ], [ %c.0, %while.cond ]
  %key.addr.1 = phi ptr [ %incdec.ptr, %land.rhs ], [ %key.addr.0, %while.cond ]
  %1 = phi i1 [ false, %while.cond ], [ %tobool, %land.rhs ]
  br i1 %1, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %mul = mul i32 %h.0, 33
  %conv1 = zext i8 %c.1 to i32
  %add = add i32 %mul, %conv1
  br label %while.cond, !llvm.loop !79

while.end:                                        ; preds = %land.end
  ret i32 %h.0
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @strcmp(ptr noundef, ptr noundef) #8

; Function Attrs: nounwind uwtable
define internal void @rec_grow(ptr noundef %rec) #0 {
entry:
  %cap = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %0 = load i32, ptr %cap, align 4, !tbaa !37
  %items = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 2
  %1 = load ptr, ptr %items, align 8, !tbaa !48
  %cap1 = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %2 = load i32, ptr %cap1, align 4, !tbaa !37
  %mul = mul nsw i32 %2, 2
  store i32 %mul, ptr %cap1, align 4, !tbaa !37
  %cap2 = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 1
  %3 = load i32, ptr %cap2, align 4, !tbaa !37
  %conv = sext i32 %3 to i64
  %call = call noalias ptr @calloc(i64 noundef %conv, i64 noundef 16) #15
  %items3 = getelementptr inbounds %struct.Rec, ptr %rec, i32 0, i32 2
  store ptr %call, ptr %items3, align 8, !tbaa !48
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @perror(ptr noundef @.str.121) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %i.0 = phi i32 [ 0, %if.end ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, %0
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds %struct.Entry, ptr %1, i64 %idxprom
  %key = getelementptr inbounds %struct.Entry, ptr %arrayidx, i32 0, i32 0
  %4 = load ptr, ptr %key, align 8, !tbaa !30
  %tobool5 = icmp ne ptr %4, null
  br i1 %tobool5, label %if.then6, label %if.end12

if.then6:                                         ; preds = %for.body
  %idxprom7 = sext i32 %i.0 to i64
  %arrayidx8 = getelementptr inbounds %struct.Entry, ptr %1, i64 %idxprom7
  %key9 = getelementptr inbounds %struct.Entry, ptr %arrayidx8, i32 0, i32 0
  %5 = load ptr, ptr %key9, align 8, !tbaa !30
  %idxprom10 = sext i32 %i.0 to i64
  %arrayidx11 = getelementptr inbounds %struct.Entry, ptr %1, i64 %idxprom10
  %val = getelementptr inbounds %struct.Entry, ptr %arrayidx11, i32 0, i32 1
  %6 = load ptr, ptr %val, align 8, !tbaa !32
  call void @rec_add(ptr noundef %rec, ptr noundef %5, ptr noundef %6)
  br label %if.end12

if.end12:                                         ; preds = %if.then6, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end12
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !80

for.end:                                          ; preds = %for.cond
  call void @free(ptr noundef %1) #16
  ret void
}

; Function Attrs: nounwind allocsize(0,1)
declare noalias ptr @calloc(i64 noundef, i64 noundef) #10

; Function Attrs: nounwind
declare void @free(ptr noundef) #9

; Function Attrs: nounwind willreturn memory(read)
declare ptr @strchr(ptr noundef, i32 noundef) #8

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strcspn(ptr noundef, ptr noundef) #8

; Function Attrs: nounwind willreturn memory(none)
declare ptr @__ctype_b_loc() #6

; Function Attrs: nounwind uwtable
define internal i32 @read_sign(ptr noundef %st) #0 {
entry:
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  switch i32 %conv, label %sw.default [
    i32 45, label %sw.bb
    i32 43, label %sw.bb2
  ]

sw.bb:                                            ; preds = %entry
  %filec1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %3 = load i64, ptr %filec1, align 8, !tbaa !52
  %inc = add i64 %3, 1
  store i64 %inc, ptr %filec1, align 8, !tbaa !52
  br label %return

sw.bb2:                                           ; preds = %entry
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %4 = load i64, ptr %filec3, align 8, !tbaa !52
  %inc4 = add i64 %4, 1
  store i64 %inc4, ptr %filec3, align 8, !tbaa !52
  br label %return

sw.default:                                       ; preds = %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb2, %sw.bb
  %retval.0 = phi i32 [ 1, %sw.default ], [ 1, %sw.bb2 ], [ -1, %sw.bb ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define internal i32 @read_int(ptr noundef %st) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %ret.0 = phi i32 [ 0, %entry ], [ %sub, %for.inc ]
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %0 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %1 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %1, 0
  %arrayidx = getelementptr inbounds i8, ptr %0, i64 %add
  %2 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %2 to i32
  %tobool = icmp ne i32 %conv, 0
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %for.cond
  %call = call ptr @__ctype_b_loc() #14
  %3 = load ptr, ptr %call, align 8, !tbaa !24
  %file1 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %4 = load ptr, ptr %file1, align 8, !tbaa !51
  %filec2 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %5 = load i64, ptr %filec2, align 8, !tbaa !52
  %add3 = add i64 %5, 0
  %arrayidx4 = getelementptr inbounds i8, ptr %4, i64 %add3
  %6 = load i8, ptr %arrayidx4, align 1, !tbaa !53
  %conv5 = zext i8 %6 to i32
  %idxprom = sext i32 %conv5 to i64
  %arrayidx6 = getelementptr inbounds i16, ptr %3, i64 %idxprom
  %7 = load i16, ptr %arrayidx6, align 2, !tbaa !60
  %conv7 = zext i16 %7 to i32
  %and = and i32 %conv7, 2048
  %tobool8 = icmp ne i32 %and, 0
  br label %land.end

land.end:                                         ; preds = %land.rhs, %for.cond
  %8 = phi i1 [ false, %for.cond ], [ %tobool8, %land.rhs ]
  br i1 %8, label %for.body, label %for.end

for.body:                                         ; preds = %land.end
  %mul = mul nsw i32 %ret.0, 10
  %file9 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %9 = load ptr, ptr %file9, align 8, !tbaa !51
  %filec10 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %10 = load i64, ptr %filec10, align 8, !tbaa !52
  %add11 = add i64 %10, 0
  %arrayidx12 = getelementptr inbounds i8, ptr %9, i64 %add11
  %11 = load i8, ptr %arrayidx12, align 1, !tbaa !53
  %conv13 = zext i8 %11 to i32
  %add14 = add nsw i32 %mul, %conv13
  %sub = sub nsw i32 %add14, 48
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %filec15 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %12 = load i64, ptr %filec15, align 8, !tbaa !52
  %inc = add i64 %12, 1
  store i64 %inc, ptr %filec15, align 8, !tbaa !52
  br label %for.cond, !llvm.loop !81

for.end:                                          ; preds = %land.end
  ret i32 %ret.0
}

; Function Attrs: nounwind uwtable
define internal ptr @read_sci(ptr noundef %st, double noundef %val, i32 noundef %isint) #0 {
entry:
  %call = call ptr @__ctype_tolower_loc() #14
  %0 = load ptr, ptr %call, align 8, !tbaa !24
  %file = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 0
  %1 = load ptr, ptr %file, align 8, !tbaa !51
  %filec = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %2 = load i64, ptr %filec, align 8, !tbaa !52
  %add = add i64 %2, 0
  %arrayidx = getelementptr inbounds i8, ptr %1, i64 %add
  %3 = load i8, ptr %arrayidx, align 1, !tbaa !53
  %conv = zext i8 %3 to i32
  %idxprom = sext i32 %conv to i64
  %arrayidx1 = getelementptr inbounds i32, ptr %0, i64 %idxprom
  %4 = load i32, ptr %arrayidx1, align 4, !tbaa !22
  %cmp = icmp ne i32 %4, 101
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %finish

if.end:                                           ; preds = %entry
  %filec3 = getelementptr inbounds %struct.Tsp, ptr %st, i32 0, i32 1
  %5 = load i64, ptr %filec3, align 8, !tbaa !52
  %inc = add i64 %5, 1
  store i64 %inc, ptr %filec3, align 8, !tbaa !52
  %call5 = call i32 @read_sign(ptr noundef %st)
  %cmp6 = icmp eq i32 %call5, 1
  br i1 %cmp6, label %if.then8, label %if.else

if.then8:                                         ; preds = %if.end
  br label %if.end9

if.else:                                          ; preds = %if.end
  br label %if.end9

if.end9:                                          ; preds = %if.else, %if.then8
  %sign.0 = phi double [ 1.000000e+01, %if.then8 ], [ 1.000000e-01, %if.else ]
  %call10 = call i32 @read_int(ptr noundef %st)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end9
  %val.addr.0 = phi double [ %val, %if.end9 ], [ %mul, %for.inc ]
  %expo.0 = phi i32 [ %call10, %if.end9 ], [ %dec, %for.inc ]
  %dec = add nsw i32 %expo.0, -1
  %tobool = icmp ne i32 %expo.0, 0
  br i1 %tobool, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %mul = fmul double %val.addr.0, %sign.0
  br label %for.cond, !llvm.loop !82

for.end:                                          ; preds = %for.cond.cleanup
  br label %finish

finish:                                           ; preds = %for.end, %if.then
  %val.addr.1 = phi double [ %val, %if.then ], [ %val.addr.0, %for.end ]
  %tobool11 = icmp ne i32 %isint, 0
  br i1 %tobool11, label %if.then12, label %if.end15

if.then12:                                        ; preds = %finish
  %conv13 = fptosi double %val.addr.1 to i32
  %call14 = call ptr @mk_int(i32 noundef %conv13)
  br label %return

if.end15:                                         ; preds = %finish
  %call16 = call ptr @mk_dec(double noundef %val.addr.1)
  br label %return

return:                                           ; preds = %if.end15, %if.then12
  %retval.0 = phi ptr [ %call14, %if.then12 ], [ %call16, %if.end15 ]
  ret ptr %retval.0
}

; Function Attrs: nounwind willreturn memory(none)
declare ptr @__ctype_tolower_loc() #6

; Function Attrs: nounwind uwtable
define internal ptr @esc_str(ptr noundef %s, i32 noundef %len, i32 noundef %do_esc) #0 {
entry:
  %add = add nsw i32 %len, 1
  %conv = sext i32 %add to i64
  %mul = mul i64 %conv, 1
  %call = call noalias ptr @malloc(i64 noundef %mul) #11
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  call void @perror(ptr noundef @.str.17) #12
  call void @exit(i32 noundef 1) #13
  unreachable

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %pos.0 = phi ptr [ %call, %if.end ], [ %incdec.ptr9, %for.inc ]
  %s.addr.0 = phi ptr [ %s, %if.end ], [ %incdec.ptr10, %for.inc ]
  %idx.ext = sext i32 %len to i64
  %add.ptr = getelementptr inbounds i8, ptr %call, i64 %idx.ext
  %cmp = icmp ult ptr %pos.0, %add.ptr
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %0 = load i8, ptr %s.addr.0, align 1, !tbaa !53
  %conv2 = zext i8 %0 to i32
  %cmp3 = icmp eq i32 %conv2, 92
  br i1 %cmp3, label %land.lhs.true, label %if.else

land.lhs.true:                                    ; preds = %for.body
  %tobool5 = icmp ne i32 %do_esc, 0
  br i1 %tobool5, label %if.then6, label %if.else

if.then6:                                         ; preds = %land.lhs.true
  %incdec.ptr = getelementptr inbounds i8, ptr %s.addr.0, i32 1
  %1 = load i8, ptr %incdec.ptr, align 1, !tbaa !53
  %call7 = call i8 @esc_char(i8 noundef %1)
  store i8 %call7, ptr %pos.0, align 1, !tbaa !53
  br label %if.end8

if.else:                                          ; preds = %land.lhs.true, %for.body
  %2 = load i8, ptr %s.addr.0, align 1, !tbaa !53
  store i8 %2, ptr %pos.0, align 1, !tbaa !53
  br label %if.end8

if.end8:                                          ; preds = %if.else, %if.then6
  %s.addr.1 = phi ptr [ %incdec.ptr, %if.then6 ], [ %s.addr.0, %if.else ]
  br label %for.inc

for.inc:                                          ; preds = %if.end8
  %incdec.ptr9 = getelementptr inbounds i8, ptr %pos.0, i32 1
  %incdec.ptr10 = getelementptr inbounds i8, ptr %s.addr.1, i32 1
  br label %for.cond, !llvm.loop !83

for.end:                                          ; preds = %for.cond
  store i8 0, ptr %pos.0, align 1, !tbaa !53
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define internal i8 @esc_char(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  switch i32 %conv, label %sw.default [
    i32 110, label %sw.bb
    i32 114, label %sw.bb1
    i32 116, label %sw.bb2
    i32 10, label %sw.bb3
    i32 92, label %sw.bb4
    i32 34, label %sw.bb4
  ]

sw.bb:                                            ; preds = %entry
  br label %return

sw.bb1:                                           ; preds = %entry
  br label %return

sw.bb2:                                           ; preds = %entry
  br label %return

sw.bb3:                                           ; preds = %entry
  br label %return

sw.bb4:                                           ; preds = %entry, %entry
  br label %sw.default

sw.default:                                       ; preds = %sw.bb4, %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %retval.0 = phi i8 [ %c, %sw.default ], [ 32, %sw.bb3 ], [ 9, %sw.bb2 ], [ 13, %sw.bb1 ], [ 10, %sw.bb ]
  ret i8 %retval.0
}

; Function Attrs: nounwind uwtable
define internal void @prepend_bt(ptr noundef %st, ptr noundef %env, ptr noundef %f) #0 {
entry:
  %v = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f1 = getelementptr inbounds %struct.anon, ptr %v, i32 0, i32 3
  %name = getelementptr inbounds %struct.anon.2, ptr %f1, i32 0, i32 0
  %0 = load ptr, ptr %name, align 8, !tbaa !41
  %tobool = icmp ne ptr %0, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup.cont

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %env.addr.0 = phi ptr [ %env, %if.end ], [ %2, %for.inc ]
  %next = getelementptr inbounds %struct.Rec, ptr %env.addr.0, i32 0, i32 3
  %1 = load ptr, ptr %next, align 8, !tbaa !33
  %tobool2 = icmp ne ptr %1, null
  br i1 %tobool2, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %next3 = getelementptr inbounds %struct.Rec, ptr %env.addr.0, i32 0, i32 3
  %2 = load ptr, ptr %next3, align 8, !tbaa !33
  br label %for.cond, !llvm.loop !84

for.end:                                          ; preds = %for.cond
  %call = call ptr @entry_get(ptr noundef %env.addr.0, ptr noundef @.str.60)
  %val = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %3 = load ptr, ptr %val, align 8, !tbaa !32
  %t = getelementptr inbounds %struct.Val, ptr %3, i32 0, i32 0
  %4 = load i32, ptr %t, align 8, !tbaa !6
  %cmp = icmp eq i32 %4, 2048
  br i1 %cmp, label %land.lhs.true, label %if.end27

land.lhs.true:                                    ; preds = %for.end
  %val4 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %5 = load ptr, ptr %val4, align 8, !tbaa !32
  %v5 = getelementptr inbounds %struct.Val, ptr %5, i32 0, i32 1
  %p = getelementptr inbounds %struct.anon, ptr %v5, i32 0, i32 4
  %car = getelementptr inbounds %struct.anon.3, ptr %p, i32 0, i32 0
  %6 = load ptr, ptr %car, align 8, !tbaa !46
  %t6 = getelementptr inbounds %struct.Val, ptr %6, i32 0, i32 0
  %7 = load i32, ptr %t6, align 8, !tbaa !6
  %cmp7 = icmp eq i32 %7, 64
  br i1 %cmp7, label %land.lhs.true8, label %if.end27

land.lhs.true8:                                   ; preds = %land.lhs.true
  %v9 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f10 = getelementptr inbounds %struct.anon, ptr %v9, i32 0, i32 3
  %name11 = getelementptr inbounds %struct.anon.2, ptr %f10, i32 0, i32 0
  %8 = load ptr, ptr %name11, align 8, !tbaa !41
  %val12 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %9 = load ptr, ptr %val12, align 8, !tbaa !32
  %v13 = getelementptr inbounds %struct.Val, ptr %9, i32 0, i32 1
  %p14 = getelementptr inbounds %struct.anon, ptr %v13, i32 0, i32 4
  %car15 = getelementptr inbounds %struct.anon.3, ptr %p14, i32 0, i32 0
  %10 = load ptr, ptr %car15, align 8, !tbaa !46
  %v16 = getelementptr inbounds %struct.Val, ptr %10, i32 0, i32 1
  %s = getelementptr inbounds %struct.anon, ptr %v16, i32 0, i32 0
  %11 = load ptr, ptr %s, align 8, !tbaa !29
  %val17 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %12 = load ptr, ptr %val17, align 8, !tbaa !32
  %v18 = getelementptr inbounds %struct.Val, ptr %12, i32 0, i32 1
  %p19 = getelementptr inbounds %struct.anon, ptr %v18, i32 0, i32 4
  %car20 = getelementptr inbounds %struct.anon.3, ptr %p19, i32 0, i32 0
  %13 = load ptr, ptr %car20, align 8, !tbaa !46
  %v21 = getelementptr inbounds %struct.Val, ptr %13, i32 0, i32 1
  %s22 = getelementptr inbounds %struct.anon, ptr %v21, i32 0, i32 0
  %14 = load ptr, ptr %s22, align 8, !tbaa !29
  %call23 = call i64 @strlen(ptr noundef %14) #17
  %call24 = call i32 @strncmp(ptr noundef %8, ptr noundef %11, i64 noundef %call23) #17
  %tobool25 = icmp ne i32 %call24, 0
  br i1 %tobool25, label %if.end27, label %if.then26

if.then26:                                        ; preds = %land.lhs.true8
  br label %cleanup

if.end27:                                         ; preds = %land.lhs.true8, %land.lhs.true, %for.end
  %v28 = getelementptr inbounds %struct.Val, ptr %f, i32 0, i32 1
  %f29 = getelementptr inbounds %struct.anon, ptr %v28, i32 0, i32 3
  %name30 = getelementptr inbounds %struct.anon.2, ptr %f29, i32 0, i32 0
  %15 = load ptr, ptr %name30, align 8, !tbaa !41
  %call31 = call ptr @mk_sym(ptr noundef %st, ptr noundef %15)
  %val32 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  %16 = load ptr, ptr %val32, align 8, !tbaa !32
  %call33 = call ptr @mk_pair(ptr noundef %call31, ptr noundef %16)
  %val34 = getelementptr inbounds %struct.Entry, ptr %call, i32 0, i32 1
  store ptr %call33, ptr %val34, align 8, !tbaa !32
  br label %cleanup

cleanup:                                          ; preds = %if.end27, %if.then26
  %cleanup.dest.slot.0 = phi i32 [ 0, %if.end27 ], [ 1, %if.then26 ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 0, label %cleanup.cont
    i32 1, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup, %cleanup, %if.then
  ret void

unreachable:                                      ; preds = %cleanup
  unreachable
}

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #3 = { cold "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #4 = { noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #5 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #6 = { nounwind willreturn memory(none) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #7 = { nocallback nofree nosync nounwind willreturn }
attributes #8 = { nounwind willreturn memory(read) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #9 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #10 = { nounwind allocsize(0,1) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #11 = { nounwind allocsize(0) }
attributes #12 = { cold }
attributes #13 = { noreturn nounwind }
attributes #14 = { nounwind willreturn memory(none) }
attributes #15 = { nounwind allocsize(0,1) }
attributes #16 = { nounwind }
attributes #17 = { nounwind willreturn memory(read) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!6 = !{!7, !8, i64 0}
!7 = !{!"Val", !8, i64 0, !10, i64 8}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"", !11, i64 0, !12, i64 8, !14, i64 24, !15, i64 40, !14, i64 72, !11, i64 88}
!11 = !{!"any pointer", !8, i64 0}
!12 = !{!"", !13, i64 0, !13, i64 8}
!13 = !{!"double", !8, i64 0}
!14 = !{!"", !11, i64 0, !11, i64 8}
!15 = !{!"", !11, i64 0, !11, i64 8, !11, i64 16, !11, i64 24}
!16 = !{!7, !11, i64 88}
!17 = distinct !{!17, !18, !19}
!18 = !{!"llvm.loop.mustprogress"}
!19 = !{!"llvm.loop.unroll.disable"}
!20 = !{!7, !13, i64 16}
!21 = !{!7, !13, i64 24}
!22 = !{!23, !23, i64 0}
!23 = !{!"int", !8, i64 0}
!24 = !{!11, !11, i64 0}
!25 = distinct !{!25, !18, !19}
!26 = !{!27, !11, i64 48}
!27 = !{!"Tsp", !11, i64 0, !28, i64 8, !11, i64 16, !11, i64 24, !11, i64 32, !11, i64 40, !11, i64 48, !11, i64 56, !11, i64 64, !28, i64 72}
!28 = !{!"long", !8, i64 0}
!29 = !{!7, !11, i64 8}
!30 = !{!31, !11, i64 0}
!31 = !{!"Entry", !11, i64 0, !11, i64 8}
!32 = !{!31, !11, i64 8}
!33 = !{!34, !11, i64 16}
!34 = !{!"Rec", !23, i64 0, !23, i64 4, !11, i64 8, !11, i64 16}
!35 = distinct !{!35, !18, !19}
!36 = !{!34, !23, i64 0}
!37 = !{!34, !23, i64 4}
!38 = !{!27, !11, i64 56}
!39 = !{!7, !11, i64 32}
!40 = !{!7, !11, i64 40}
!41 = !{!7, !11, i64 48}
!42 = !{!7, !11, i64 56}
!43 = !{!7, !11, i64 64}
!44 = !{!7, !11, i64 72}
!45 = !{!7, !11, i64 96}
!46 = !{!7, !11, i64 80}
!47 = distinct !{!47, !18, !19}
!48 = !{!34, !11, i64 8}
!49 = !{!27, !11, i64 24}
!50 = distinct !{!50, !18, !19}
!51 = !{!27, !11, i64 0}
!52 = !{!27, !28, i64 8}
!53 = !{!8, !8, i64 0}
!54 = distinct !{!54, !18, !19}
!55 = distinct !{!55, !18, !19}
!56 = distinct !{!56, !18, !19}
!57 = distinct !{!57, !18, !19}
!58 = !{!27, !11, i64 16}
!59 = distinct !{!59, !18, !19}
!60 = !{!61, !61, i64 0}
!61 = !{!"short", !8, i64 0}
!62 = distinct !{!62, !18, !19}
!63 = distinct !{!63, !18, !19}
!64 = distinct !{!64, !18, !19}
!65 = distinct !{!65, !18, !19}
!66 = distinct !{!66, !18, !19}
!67 = distinct !{!67, !18, !19}
!68 = distinct !{!68, !18, !19}
!69 = distinct !{!69, !18, !19}
!70 = distinct !{!70, !18, !19}
!71 = distinct !{!71, !18, !19}
!72 = distinct !{!72, !18, !19}
!73 = !{!27, !11, i64 40}
!74 = !{!27, !11, i64 32}
!75 = !{!27, !11, i64 64}
!76 = !{!27, !28, i64 72}
!77 = distinct !{!77, !18, !19}
!78 = distinct !{!78, !18, !19}
!79 = distinct !{!79, !18, !19}
!80 = distinct !{!80, !18, !19}
!81 = distinct !{!81, !18, !19}
!82 = distinct !{!82, !18, !19}
!83 = distinct !{!83, !18, !19}
!84 = distinct !{!84, !18, !19}
