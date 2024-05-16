module IDE

/*
 * Import this module in a Rascal terminal and execute `main()`
 * to enable language services in the IDE.
 */

import util::LanguageServer;
import util::Reflective;
import util::IDEServices;

import Syntax;
import Check;
import App;
import Message;
import ParseTree;


set[LanguageService] myLanguageContributor() = {
    parser(Tree (str input, loc src) {
        return parse(#start[Form], input, src);
    }),
    lenses(myLenses),
    executor(myCommands),
    summarizer(mySummarizer
        , providesDocumentation = false
        , providesDefinitions = false
        , providesReferences = false
        , providesImplementations = false)
};

Summary mySummarizer(loc origin, start[Form] input) {
  return summary(origin, messages = {<m.at, m> | Message m <- check(input) });
}

data Command
  = runQuestionnaire(start[Form] form);

rel[loc,Command] myLenses(start[Form] input) = {<input@\loc, runQuestionnaire(input, title="Run...")>};


void myCommands(runQuestionnaire(start[Form] form)) {
    showInteractiveContent(runQL(form));
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


