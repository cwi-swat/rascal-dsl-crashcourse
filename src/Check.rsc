module Check

import Resolve;
import Message;
import IO;
import ParseTree;

extend Syntax;

syntax Type = "*unknown*";

alias TEnv = map[str, Type];

TEnv collect(start[Form] f) 
  = ( "<x>": t | /(Question)`<Str _> <Id x>: <Type t>` := f )
  + ( "<x>": t | /(Question)`<Str _> <Id x>: <Type t> = <Expr _>` := f );


/*
 * typeOf: compute the type of expressions
 */

// the fall back type is *unknown*
default Type typeOf(Expr _, TEnv env) = (Type)`*unknown*`;

// a reference has the type of its declaration
Type typeOf((Expr)`<Id x>`, TEnv env) = env["<x>"]
    when "<x>" in env;

Type typeOf((Expr)`<Expr _> + <Expr _>`, TEnv env) = (Type)`integer`;

//ASSIGNMENT add a few more or (or all) cases for typeOf.

/*
 * Checking forms
 */

set[Message] check(start[Form] form)
  = { *check(q, env) | Question q <- form.top.questions }
  when TEnv env := collect(form);

/*
 * Checking questions
 */

// by default, there are no errors
default set[Message] check(Question _, TEnv _) = {};


// a computed question must have an expression that is type 
// compatible with its declared type.
set[Message] check((Question)`<Str _> <Id x>: <Type t> = <Expr e>`, TEnv env)
    = { error("incompatible type", e.src) | t !:= typeOf(e, env) }
    + check(e, env);

// ASSIGNMENT complete the check definition by adding cases 
// for if-then, if-then-else, and block.

set[Message] check((Question)`if (<Expr c>) <Question q>`, TEnv env)
    = { error("condition must be boolean", c.src) | (Type)`boolean` !:= typeOf(c, env) }
    + check(c, env) + check(q, env);

set[Message] check((Question)`{<Question* qs>}`, TEnv env)
    = { *check(q, env) | Question q <- qs };


/*
 * Checking expressions
 */


// when the other cases fail, there are no errors
default set[Message] check(Expr _, TEnv env) = {};

set[Message] check(e:(Expr)`<Id x>`, TEnv env) = {error("undefined question", x.src)}
    when "<x>" notin env;

set[Message] check((Expr)`(<Expr e>)`, TEnv env) = check(e, env);

// ASSIGNMENT, add a couple of more cases to define type checking 
// think about the different type signature of arithmetic
// comparisons (<, >, ==, etc.), and booleans (&&, etc.)

set[Message] check(e:(Expr)`<Expr x> - <Expr y>`, TEnv env)
    = { error("invalid types for subtraction", e.src) | 
        (Type)`integer` !:= typeOf(x, env) || (Type)`integer` !:= typeOf(y, env) }
    + check(x, env) + check(y, env);

set[Message] check(e:(Expr)`<Expr x> * <Expr y>`, TEnv env)
    = { error("invalid types for multiplication", e.src) | 
        (Type)`integer` !:= typeOf(x, env) || (Type)`integer` !:= typeOf(y, env) }
    + check(x, env) + check(y, env);


void printTEnv(TEnv tenv) {
    for (str x <- tenv) {
        println("<x>: <tenv[x]>");
    }
}

void checkSnippets() {
    start[Form] pt = parse(#start[Form], |project://rascal-dsl-crashcourse/examples/tax.myql|);
    check(pt);
}
 
