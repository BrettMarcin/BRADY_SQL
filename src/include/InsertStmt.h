//
// Created by Brett Marcinkiewicz on 11/14/20.
//

#ifndef TEST_BISON_INSERTSTMT_H
#define TEST_BISON_INSERTSTMT_H

#include "string"
#include "sql/Enums.h"
#include "Query.h"

using namespace std;

class InsertStmt : public Node {
    public:
        InsertStmt(NodeTag type, string tableToInsert, list<InsertColumn*>* insertColumns);
    protected:
        string tableToInsert;
        list<InsertColumn*>* insertColumns;
};


#endif //TEST_BISON_INSERTSTMT_H
