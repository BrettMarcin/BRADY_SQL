//
// Created by Brett Marcinkiewicz on 11/6/20.
//

#ifndef TEST_BISON_QUERY_H
#define TEST_BISON_QUERY_H

#include <map>
#include <list>
#include <string>
#include <vector>
#include "NodeTree.h"
#include "sql/Enums.h"

using namespace std;

class Node {
    public:
        Node(NodeTag type) {
            this->type = type;
        }
        NodeTag getNodeTag() {
            return type;
        }
        void setNodeTag(NodeTag type) {
            this->type = type;
        }
        Node() {

        }
    protected:
        NodeTag type;
};

class TypeName {
    public:
        TypeName() {

        }
        TypeName(ColType colType) {
            this->colType = colType;
        }

    protected:
        ColType colType;
};

class VarCharTypeName : public TypeName {
    public:
        VarCharTypeName(ColType type) : TypeName(type) {}
        void setLength(int length) {
            this->length;
        }
    protected:
        int length;
};

class CreateDatabaseStmt : public Node {
    public:
        CreateDatabaseStmt(NodeTag type) : Node(type) {}
        void setDatabaseName(string databaseName) {
            this->databaseName = databaseName;
        }
    private:
        string databaseName;
};

class ColumnDef : public Node {
    public:
        ColumnDef(NodeTag theTag) : Node(theTag){}
        void setColName(string colName) {
            this->colName = colName;
        }
        void setType(TypeName* type) {
            this->type = type;
        }
    protected:
        string colName;
        TypeName* type;
//    Oid			collOid;
};

class CreateTableStmt : public Node {
    public:
        CreateTableStmt(NodeTag theTag) : Node(theTag){}
        void setTableElementsList(list<Node*>* tableElementsList) {
            this->tableElementsList = tableElementsList;
        }
        void setTableName(string tableName) {
            this->tableName =  tableName;
        }
    protected:
        string tableName;
        list<Node*>* tableElementsList;
};

class GenericType {
    public:
        GenericType(Generic theType) {
            this->theType = theType;
        }
        void setIntValue(int intValue) {
            this->intValue = intValue;
        }
        void setStringValue(string stringValue) {
            this->stringValue = stringValue;
        }
    protected:
        Generic theType;
        int intValue;
        string stringValue;
};

class InsertColumn {
    public:
        InsertColumn() {
            newValue = NULL;
        }
        InsertColumn(string colName, GenericType* newValue) {
            this->colName = colName;
            this->newValue = newValue;
        }
    protected:
        string colName;
        GenericType* newValue;
};

#endif TEST_BISON_QUERY_H