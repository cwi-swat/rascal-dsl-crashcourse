module App

import salix::HTML;
import salix::App;
import salix::Core;
import salix::Index;

import Eval; // we only use eval of expressions 
import Syntax;

import String;
import ParseTree;

alias Model = tuple[start[Form] form, VEnv env];

App[Model] runQL(start[Form] ql) = webApp(qlApp(ql), |project://rascal-dsl-crashcourse/src/main/rascal|);

SalixApp[Model] qlApp(start[Form] ql, str id="root") 
  = makeApp(id, 
        Model() { return <ql, initialEnv(ql)>; }, 
        withIndex("<ql.top.name>", id, view, css=["https://cdn.simplecss.org/simple.min.css"]), 
        update);


data Msg
  = updateInt(str name, str n)
  | updateBool(str name, bool b)
  | updateStr(str name, str s)
  ;


Model update(Msg msg, Model model) {
    Input inp;
    switch (msg) {
        case updateInt(str q, str n):
            inp = user(q, vint(toInt(n)));
        case updateBool(str q, bool b):
            inp = user(q, vbool(b));
        case updateStr(str q, str s):
            inp = user(q, vstr(s));
    }
    model.env = eval(model.form, inp, model.env);
    return model;
}

void view(Model model) {
    h3(model.form.top.name);
    form(() {
        table(() {
            tbody(() {
                for (Question q <- model.form.top.questions) {
                    viewQuestion(q, model);
                }
            });
        });
    });
}

// ASSIGNMENT: complete rendering of questions for
// if-then, if-then-else, block, and computed questions.
// to evaluate conditions call eval, and pass in model.env
// for the latter take inspiration from the normal question rendering
// and use the attribute disabeld(true) to make them read only. 
void viewQuestion(Question q, Model model) {

    switch (q) {
        case (Question)`if (<Expr e>) <Question then>`: {
            if (eval(e, model.env) == vbool(true)) {
                viewQuestion(then, model);
            }
        }

        case (Question)`{<Question* qs>}`: {
            for (Question q <- qs) {
                viewQuestion(q, model);
            }
        }
        case (Question)`<Str s> <Id x>: <Type t>`: {
            tr(() {
                td(() {
                    label("<s>");
                });

                td(() {
                    switch (<t, model.env["<x>"]>) {
                        case <(Type)`integer`, vint(int i)>:
                            input(\type("number"), \value("<i>"), onChange(partial(updateInt, "<x>")));
                        case <(Type)`boolean`, vbool(bool b)>:
                            input(\type("checkbox"),checked(b), onClick(updateBool("<x>", !b)));
                        case <(Type)`string`, vstr(str s)>:
                            input(\type("text"), \value(s), onChange(partial(updateStr, "<x>")));
                    }    
                });
            });
        }

        case (Question)`<Str s> <Id x>: <Type t> = <Expr e>`: {
            tr(() {
                td(() {
                    label("<s>");
                });

                td(() {
                    switch (<t, model.env["<x>"]>) {
                        case <(Type)`integer`, vint(int i)>:
                            input(\type("number"), \value("<i>"), disabled(true));
                        case <(Type)`boolean`, vbool(bool b)>:
                            input(\type("checkbox"),checked(b), disabled(true));
                    }    
                });   
            });
        }

        default: throw "unknown question type";

    }
}
