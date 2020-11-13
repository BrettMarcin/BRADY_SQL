//
// Created by Brett Marcinkiewicz on 11/6/20.
//

#ifndef TEST_BISON_QUERY_H
#define TEST_BISON_QUERY_H

#include <map>
#include <list>
#include <string>
#include <vector>

using namespace std;

typedef enum NodeTag
{
    T_Query,
    T_SelectStmt,
    T_CreateStmt,
    T_ColumnDef
};

typedef enum ColType
{
    T_INT,
    T_VARCHAR
};

class Node {
    public:
        Node(NodeTag type) {
            this->type = type;
        }
        NodeTag getNodeTag() {
            return type;
        }
        Node() {

        }
    private:
        NodeTag type;
};

class TypeName {
    public:
        TypeName() {

        }
        TypeName(ColType type) {
            this->type = type;
        }

    private:
        ColType type;
};

class VarCharTypeName : TypeName {
public:
    VarCharTypeName(ColType type) : TypeName(type) {}
    private:
        int length;
};

//class SelectStmt : Node {
//    public:
//        SelectStmt(NodeTag type) : Node(type) {}
//    private:
//        list<string>    *targetList;
//        list<string>    *fromClause;
//        Node	        *whereClause;
//};

class ColumnDef : Node {
    public:
        ColumnDef(NodeTag theTag) : Node(theTag){}
    private:
        string colName;
        TypeName type;
//    Oid			collOid;
};

class CreateStmt : Node {
    public:
        CreateStmt(NodeTag theTag) : Node(theTag){}
        void setTableElementsList(list<Node>* tableElementsList) {
            this->tableElementsList = tableElementsList;
        }
    private:
        string tableName;
        list<Node>* tableElementsList;
};


///// my stuff
enum QueryCommands {SELECT_CMD, CREATE_TABLE_CMD, CREATE_DATABASE_CMD};
enum ColumnTypes {INT_TYPE, VARCHAR_TYPE};
enum CompareOperators {greaterThan, lessThan, equal};
enum CompareSqlOperators {AND, OR};


//typedef struct CreateDatabaseStmt {
//    string name;
//};
//
//typedef struct CreateTableStmt {
//    string name;
//    map<string, ColumnTypes> columns;
////    list<string> columnNames;
////    list<ColumnTypes> columnTypes;
//    string primaryKey;
//};
//
//typedef struct DatabaseStmt {
//    string name;
//};
//
//typedef struct ColumnComparison {
//    bool compareColumns;
//    string columnName;
//    string columnCompare;
//    CompareSqlOperators compareSqlOperators ;
//    CompareOperators compareOperators;
//};
//
//typedef struct SelectStmt {
//    bool getAll;
//    map<string, ColumnTypes> columns;
//    string tableName;
//    list<ColumnComparison> conditions;
//
//};

//CreateTableStmt

////struct SelectStmt {
////    bool getAll;
////    map<string, ColumnTypes> m;
////};
//
////struct Query {
////    QueryCommands queryType;
////CreateTableStmt
////};
//
//class SelectStmt {
//    public:
//        void setTableName(string);
//    private:
//        bool getAll;
//        map<string, ColumnTypes> m;
//        string tableName;
//        bool hasConditions;
//        list<string> conditions;
//        list<string> columnCond;
//};
//
//class Query {
//    public:
//        QueryCommands QueryCmd;
//        void* value;
//
//};

// Compatibility with Bison 2.3:

#endif TEST_BISON_QUERY_H