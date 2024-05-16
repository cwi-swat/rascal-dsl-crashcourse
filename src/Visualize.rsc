module Visualize

import Syntax;

import vis::Graphs;
import Content;
import ParseTree;



rel[loc, str, str] dependsOn(q:(Question)`<Str _> <Id x>: <Type _> = <Expr e>`)
  = { <q.src, "<x>", "<y>"> | /(Expr)`<Id y>` := e };

default rel[loc,str,str] dependsOn(Question _) = {};

rel[loc, str, loc, str] dataDeps(rel[loc, str] defs, start[Form] form) {
    rel[loc, str, str] deps = { *dependsOn(q) | /Question q := form };

    return { <l1, x, l2, y> | <loc l1, str x, str y> <- deps, <loc l2, y> <- defs };
}


Content visualize(start[Form] f) {
    rel[loc, str] defs = { <q.src, "<x>"> | /q:(Question)`<Str _> <Id x>: <Type _>` := f }
        + { <q.src, "<x>"> | /q:(Question)`<Str _> <Id x>: <Type _> = <Expr _>` := f };

    
    str labeler(loc l) = x when <l, str x> <- defs;

    deps = dataDeps(defs, f);

    return graph([ <l1, l2> | <l1, _, l2, _> <- deps ], nodeLabeler=labeler, title="Data Dependencies");
}