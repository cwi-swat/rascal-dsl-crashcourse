module Eval

import Syntax;

import String;
import ParseTree;
import IO;

/*
 * Implement big-step semantics for QL
 */
 
// NB: Eval may assume the form is type- and name-correct.


// Semantic domain for expressions (values)
data Value
  = vint(int n)
  | vbool(bool b)
  | vstr(str s)
  ;

// The value environment, mapping question names to values.
alias VEnv = map[str name, Value \value];

// Modeling user input
data Input = user(str question, Value \value);
  

Value type2default((Type)`integer`) = vint(0);
Value type2default((Type)`string`) = vstr("");
Value type2default((Type)`boolean`) = vbool(false);


// ASSIGNMENT: produce an environment which for each question has a default value
// (e.g. 0 for int, "" for str etc.)
// use the function type2default function defined above.
// use visit to traverse the form an match on normal questions and computed questions.
VEnv initialEnv(start[Form] f) {
  VEnv venv = ();
  visit (f) {
    case (Question)`<Str _> <Id x>: <Type t>`: 
      venv["<x>"] = type2default(t);

    case (Question)`<Str _> <Id x>: <Type t> = <Expr _>`: 
      venv["<x>"] = type2default(t);
  }
  return venv;
}

// ASSIGNMENT: complete the evaluation of expressions.
// look at the grammar which cases need to be (still) implemented.
// have a look at the examples to understand how
// concrete pattern matching works.

Value eval((Expr)`<Id x>`, VEnv venv) = venv["<x>"];

Value eval((Expr)`<Bool b>`, VEnv venv) = vbool("<b>" == "true");

Value eval((Expr)`<Int i>`, VEnv venv) = vint(toInt("<i>"));

Value eval((Expr)`<Expr lhs> == <Expr rhs>`, VEnv venv) 
  = vbool(eval(lhs, venv) == eval(rhs, venv));

// note the escaping of < as \<
// note further how the results of the recursive calls are unpacked using pattern matching.
Value eval((Expr)`<Expr lhs> \< <Expr rhs>`, VEnv venv) = vbool(i < j)
  when 
    vint(int i) := eval(lhs, venv),
    vint(int j) := eval(rhs, venv);


Value eval((Expr)`<Expr lhs> + <Expr rhs>`, VEnv venv) = vint(i - j)
  when 
    vint(int i) := eval(lhs, venv),
    vint(int j) := eval(rhs, venv);



// Because of out-of-order use and declaration of questions
// we use the solve primitive in Rascal to find the fixpoint of venv.
VEnv eval(start[Form] f, Input inp, VEnv venv) {
  return solve (venv) {
    venv = evalOnce(f, inp, venv);
  }
}

// evaluate the questionnaire in one round 
VEnv evalOnce(start[Form] f, Input inp, VEnv venv) 
  = ( venv | eval(q, inp, it) | Question q <- f.top.questions );


// ASSIGNMENT complete the question interpreter
// by adding cases for computed questions, if-then, if-then-else, and block.
VEnv eval(Question q, Input inp, VEnv venv) {
  switch (q) {
    case (Question)`<Str _> <Id x>: <Type _>`: {
      if ("<x>" == inp.question) {
        return venv + ("<x>": inp.\value);
      }
    }
  }
  return venv;
}


void evalSnippets() {
  start[Form] pt = parse(#start[Form], |project://rascal-dsl-crashcourse/examples/tax.myql|);

  env = initialEnv(pt);
  env2 = eval(pt, user("hasSoldHouse", vbool(true)), env);
  env3 = eval(pt, user("sellingPrice", vint(1000)), env2);
  env4 = eval(pt, user("privateDebt", vint(500)), env3);

  for (Input u <- [user("hasSoldHouse", vbool(true)), user("sellingPrice", vint(1000)), user("privateDebt", vint(500))]) {
    env = eval(pt, u, env);
    println(env);
  }
}