#include <iostream>
#include "include/sql/Query.h"
#include "src/sql/Driver.hh"

int main() {
    int res = 0;
    Driver drv;
    drv.parse("CREATE TABLE apple ( hi INT );");
    Node* result = drv.result;
    CreateStmt* createNode = NULL;
    switch (result->getNodeTag()) {
        case T_CreateStmt:
            createNode = (CreateStmt*)result;
            break;
    }
    return 0;
}
