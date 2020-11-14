//
// Created by Brett Marcinkiewicz on 11/14/20.
//

#include "InsertStmt.h"


InsertStmt::InsertStmt(NodeTag type, string tableToInsert, list<InsertColumn*>* insertColumns) : Node(type) {
    this->tableToInsert = tableToInsert;
    this->insertColumns = insertColumns;
}