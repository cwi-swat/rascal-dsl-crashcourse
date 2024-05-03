module IDE

/*
 * Import this module in a Rascal terminal and execute `main()`
 * to enable language services in the IDE.
 */

import util::LanguageServer;
import util::Reflective;

import IO;

import Syntax;
import Resolve;
import Message;
import ParseTree;


set[LanguageService] myLanguageContributor() = {
    parser(Tree (str input, loc src) {
        return parse(#start[Form], input, src);
    }),
    summarizer(mySummarizer
        , providesDocumentation = false
        , providesDefinitions = true
        , providesReferences = false
        , providesImplementations = false)
};

Summary mySummarizer(loc origin, start[Form] input) {
  RefGraph g = resolve(input);
  return summary(origin, definitions = g.useDef);
}

void main() {
    registerLanguage(
        language(
            pathConfig(srcs = [|std:///|, |project://rascal-dsl-crashcourse/src|]),
            "QL",
            "myql",
            "IDE",
            "myLanguageContributor"
        )
    );
}


