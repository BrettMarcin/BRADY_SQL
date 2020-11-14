#include <iostream>
#include <sql/SelectStmt.h>
#include "src/include/Query.h"
#include "src/include/sql/Driver.hh"

void checkOutputOfParse(Node* result);

int main() {
    int res = 0;
    Driver drv;
//    drv.parse("CREATE TABLE apple ( hi INT );");
//    Node* result = drv.result;
//    checkOutputOfParse(result);

    drv.parse("SELECT * FROM hello WHERE A == B AND C > D;");
    Node* result = drv.result;
    checkOutputOfParse(result);

    return 0;
}

void checkOutputOfParse(Node* result) {
    CreateTableStmt* createNode = NULL;
    SelectStmt* selectNode = NULL;

    switch (result->getNodeTag()) {
        case T_CreateTableStmt:
            createNode = (CreateTableStmt*)result;
            break;

        case T_SelectStmt:
            selectNode = (SelectStmt*)result;
            break;
    }
}
