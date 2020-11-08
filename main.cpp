#include <iostream>
#include "include/sql/Query.h"

extern void scan_string(const char* str);
extern QueryStmt return_ob();
extern int yyparse (void);

int main() {
//    std::cout << "Hello, World!" << std::endl;
//    char string[] = "String to be parsed.";
//    YY_BUFFER_STATE buffer = yy_scan_string(string);
//    yyparse();
    char command[] = "CREATE DATABASE a;";
    scan_string(command);
    int success = yyparse();
    QueryStmt st = return_ob();

    char command2[] = "CREATE TABLE b (INT a, INT b, VARCHAR(30) c );";
    scan_string(command2);
    yyparse();
    QueryStmt st2 = return_ob();
    if (st.queryCmd == CREATE_DATABASE_CMD) {
        cout << "Create dataabse" << endl;
    }
    if (!success) {
        cout << "Correct" << endl;
        QueryStmt st = return_ob();
    } else {
        cout << "Failed" << endl;
    }
    return 0;
}
