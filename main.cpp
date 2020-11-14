#include <iostream>
#include <sql/SelectStmt.h>
#include <InsertStmt.h>
#include "src/include/Query.h"
#include "src/include/sql/Driver.hh"

void checkOutputOfParse(Node* result);

int main() {
    int res = 0;
    Driver drv;
    drv.parse("INSERT INTO theTable a = 1, ab = 'theString';");

    if (drv.res == 1) {
        Node* result = drv.result;
        checkOutputOfParse(result);
    } else {
        cout << "Failed to Parse String" << endl;
    }

    return 0;
}

void checkOutputOfParse(Node* result) {
    CreateTableStmt* createNode = NULL;
    SelectStmt* selectNode = NULL;
    InsertStmt* insertNode = NULL;

    switch (result->getNodeTag()) {
        case T_CreateTableStmt:
            createNode = (CreateTableStmt*)result;
            break;

        case T_SelectStmt:
            selectNode = (SelectStmt*)result;
            break;
        case T_InsertStmt:
            insertNode = (InsertStmt*)result;
            break;
    }
}
