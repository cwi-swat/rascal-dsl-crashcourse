module Flatten

import Syntax;


start[Form] flatten(start[Form] form) {
    list[Question] qs = [ *flatten(q, (Expr)`true`) | Question q <- form.top.questions ];
    form.top.questions = lst2seq(qs);
    return form;
}

list[Question] flatten((Question)`{<Question* qs>}`, Expr cond)
  = [ *flatten(q, cond) | Question q <- qs ];

list[Question] flatten((Question)`if (<Expr e>) <Question q>`, Expr cond)
  = flatten(q, (Expr)`<Expr cond> && <Expr e>`);

default list[Question] flatten(Question q, Expr cond)
  = [(Question)`if (<Expr cond>)
               '  <Question q>`];


Question* lst2seq(list[Question] lst) {
    Question block = (Question)`{}`;

    for (Question q <- lst, (Question)`{<Question* qs>}` := block) {
        block = (Question)`{<Question* qs>
                           '<Question q>}`;
    }
    if ((Question)`{<Question* qs>}` := block) {
        return qs;
    }
    throw "cannot happen";
}