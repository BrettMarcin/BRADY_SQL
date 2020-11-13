#include <iostream>
#include "include/sql/Query.h"
#include "src//sql/Driver.hh"

//extern void scan_string(const char* str);
////extern QueryStmt return_ob();
//extern int yyparse (void);

int main() {
    int res = 0;
    Driver drv;
    drv.parse("/Users/Brett/Desktop/Programming/BRADY_SQL/new.txt");
    return 0;
}
