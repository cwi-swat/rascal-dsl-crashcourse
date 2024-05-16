module Syntax

extend lang::std::Layout;
extend lang::std::Id;

import ParseTree;
import vis::Text;
import IO;


// See bottom of this file for snippets to be pasted into the terminal.


// syntax of a questionnaire
start syntax Form 
  = "form" Id name "{" Question* questions "}"; 


// ASSIGNMENT: complete the syntax of Questions
// add normal question, computed question, block of questions, and if-then-else
// look at the examples directory for how such questions should look. 
// Docs: https://www.rascal-mpl.org/docs/Rascal/Declarations/SyntaxDefinition/
syntax Question 
  = "if" "(" Expr ")" Question !>> "else" 
  | Str Id ":" Type
  | Str Id ":" Type "=" Expr
  | "{" Question* "}"
  ;

// ASSIGNMENT: define the syntax of type keywords  
syntax Type = "integer" | "boolean" | "string";

lexical Str = [\"]![\"]* [\"];

// ASSIGNMENT define the syntax of integer literals
// Docs: https://www.rascal-mpl.org/docs/Rascal/Declarations/SyntaxDefinition/Symbol/
lexical Int = [0-9]+;

// ASSIGNMENT: define the syntax of boolean literals.
lexical Bool = "true" | "false";


// ASSIGNMENT: complete the expression grammar with expressions for
// +, -, <, <=, >, >=, ==, !=, &&, ||
// (note that in literals you have to escape < and >, like \<)
// think about what the > in the grammar entails
// similar for the keyword "left"
// hint: https://www.rascal-mpl.org/docs/Rascal/Declarations/SyntaxDefinition/Disambiguation/
syntax Expr
  = var: Id name \ "true" \"false"
  | integer: Int
  | string: Str
  | boolean: Bool
  | bracket "(" Expr ")"
  > not: "!" Expr
  > left (
      mul: Expr "*" Expr
    | div: Expr "/" Expr
  )
  > left (
      add: Expr "+" Expr
    | sub: Expr "-" Expr
  )
  > non-assoc (
      lt: Expr "\<" Expr
    | leq: Expr "\<=" Expr
    | gt: Expr "\>" Expr
    | geq: Expr "\>=" Expr
    | eq: Expr "==" Expr
    | neq: Expr "!=" Expr
  )
  > left and: Expr "&&" Expr
  > left or: Expr "||" Expr
  ;

void snippets() {
  // to enable IDE support: 
  //    import IDE;
  //    main();
  // now you can double click on files in the examples folder.


  // first do: 
  //   import ParseTree; 
  //   import Syntax;
  start[Form] pt = parse(#start[Form], |project://rascal-dsl-crashcourse/examples/tax.myql|);

  // import IO;
  // import vis::Text;
  println(prettyTree(pt)); // inspect the parse tree
  println(prettyTree(pt,src=true)); // ctrl-/cmd-click on source locations

  // if you get an ambiguity error, try:
  pt = parse(#start[Form], |project://rascal-dsl-crashcourse/examples/tax.myql|, allowAmbiguity=true);
  // then inspect (amb nodes are indicated with diamonds):
  println(prettyTree(pt));

  // you can also parse smaller snippets of code:
  Expr expr = parse(#Expr, "a + b");
  println(prettyTree(expr));

}

