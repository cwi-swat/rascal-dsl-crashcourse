
# Rascal DSL crash course

In this crash course on DSL engineering you will learn the basics of implementing a DSL in the [Rascal Language Workbench](https://www.rascal-mpl.org/):

Topics covered by the course:
- Syntax definition 
- Name resolution
- Consistency checking 
- Dynamic interpretation
- Source-to-Source transformation


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


