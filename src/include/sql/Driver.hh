#ifndef DRIVER_H
#define DRIVER_H

#include <map>
#include <string>
#include "../Query.h"
#include "../../sql/build_files/parser.hh"
#include "../../sql/build_files/location.hh"
#include <list>
#include "Enums.h"

using namespace yy;

class Driver {
public:
    Driver();
    Node* result;
    Node temp;
    std::list<Node> tempList;
    TypeName tempTypeName;
    ColType tempColType;
    std::string tempString;
    void scan_begin();
    void scan_end ();
    int parse(char* stringInput);
    yy::location location;
    std::string file;
    std::string queryStmt;
    int res;
    char* stringInput;
};

// Give Flex the prototype of yylex we want ...
#define YY_DECL \
  yy::parser::symbol_type yylex (Driver& drv)
// ... and declare it for the parser's sake.
YY_DECL;

#endif //TEST_BISON_DRIVER_H
