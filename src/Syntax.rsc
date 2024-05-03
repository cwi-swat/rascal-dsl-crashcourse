module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*

To test, enter the following in the Rascal terminal
```
import Syntax;
import ParseTree;
parse(#start[Form], |project://rascal-dsl-crashcourse/examples/tax.myql|);
```
And inspect the result and/or error. 

If syntax highlighting does not work, but you're confident the grammar is correct, issue the following in the terminal:
```
import IDE;
main();
```
Then reopen the QL file. 

*/

/*
 * Concrete syntax of QL
 */

start syntax Form 
  = "form" Id name "{" Question* questions "}"; 

// TODO: question, computed question, block, if-then-else, if-then
syntax Question = ;

// TODO: +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" // true/false are reserved keywords.
  ;
  
syntax Type = ;

lexical Str = ;

lexical Int 
  = ;

lexical Bool = ;



