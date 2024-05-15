
# Rascal DSL crash course

In this crash course on DSL engineering you will learn the basics of implementing a DSL in the [Rascal Language Workbench](https://www.rascal-mpl.org/):

Topics covered by the course:
- Syntax definition 
- Name resolution
- Consistency checking 
- Dynamic interpretation
- Source-to-Source transformation

### Preliminaries

Please install [VS Code](https://code.visualstudio.com/) and then the [Rascal VS Code extension](https://marketplace.visualstudio.com/items?itemName=usethesource.rascalmpl) (you can also find Rascal in the extension browser).

Git clone [this](https://github.com/cwi-swat/rascal-dsl-crashcourse) repository. Finally, go to the File menu of VS Code and select "Add Folder to workspace", navigate to where you've cloned the repo, and select that directory. 

Do the same sequence of steps for the following git repo: [https://github.com/cwi-swat/rascal-wax-on-wax-off](https://github.com/cwi-swat/rascal-wax-on-wax-off).

The course project comes with pre-wired IDE support for QL: as you progress through the exercises, you will notice this in the editors of the QL programs. As soon as your grammar is correct, you will see syntax highlighting. Name resolution will trigger jump-to-definition functionality (hover-click on identifiers), consistency checking will show errors as squiglies in the editor. As soon as your interpreter works, the code lens "Run" (link at top of the form) will trigger execution of the form, and the same for formatting. 

## QL

The course is based on a DSL for questionnaires, called QL. QL allows you to define simple forms with conditions and computed values.
A QL program consists of a form, containing questions. A question can be a normal question, or a computed question. A computed question has an associated expression which defines its value. Both kinds of questions have a prompt (to show to the user), an identifier (its name), and a type. The conditional construct comes in two variants if and if-else. A block construct using {} can be used to group questions.

Questions are enabled and disabled when different values are entered, depending on their conditional context.

A full type checker of QL detects:
- references to undefined questions
- duplicate question declarations with different types
- conditions that are not of the type boolean
- operands of invalid type to operators
- duplicate labels (warning)
- cyclic data and control dependencies

The language supports booleans, integers and string types.

Different data types in QL map to different (default) GUI widgets. For instance, boolean would be represented as checkboxes, intergers as numeric sliders, and strings as text fields.

Here’s a simple questionnaire in QL from the domain of tax filing:
```
form taxOfficeExample { 
  "Did you sell a house in 2010?"
    hasSoldHouse: boolean
  "Did you buy a house in 2010?"
    hasBoughtHouse: boolean
  "Did you enter a loan?"
    hasMaintLoan: boolean
    
  if (hasSoldHouse) {
    "What was the selling price?"
      sellingPrice: integer
    "Private debts for the sold house:"
      privateDebt: integer
    "Value residue:"
      valueResidue: integer = 
        (sellingPrice - privateDebt)
  }
}
```

See the folder `examples/` for example QL programs. 


### Rascal Wax On Wax Off (1 hour)

Open `Series1.rsc`, click on `Run in new Rascal terminal` (top of editor).
Fill in the blanks of the functions, and executed in the terminal. If you have time left, move on to `Series2.rsc`.
Documentation can be found [here](https://www.rascal-mpl.org/docs/GettingStarted/).

### QL Exercises (4 hours total)

Each exercise corresponds to a Rascal module, see each module for an explanation:

- `Syntax.rsc`: syntax definition (grammars and parsing)
- `Resolve.rsc` / `Check.rsc`: name resolution (linking uses to definitions), static checking (name errors and dependency errors), respectively.
- `Eval.rsc`: interpretation (run QL as a Salix web app)
- `Format.rsc`: source-to-source transformation (formatting)






