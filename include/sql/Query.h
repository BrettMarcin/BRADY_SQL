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

enum QueryCommands {SELECT_CMD, CREATE_TABLE_CMD, CREATE_DATABASE_CMD};
enum ColumnTypes {INT_TYPE, VARCHAR_TYPE};
enum CompareOperators {greaterThan, lessThan, equal};
enum CompareSqlOperators {AND, OR};

typedef struct CreateDatabaseStmt {
    string name;
};

typedef struct CreateTableStmt {
    string name;
    map<string, ColumnTypes> columns;
//    list<string> columnNames;
//    list<ColumnTypes> columnTypes;
    string primaryKey;
};

typedef struct DatabaseStmt {
    string name;
};

typedef struct ColumnComparison {
    bool compareColumns;
    string columnName;
    string columnCompare;
    CompareSqlOperators compareSqlOperators ;
    CompareOperators compareOperators;
};

typedef struct SelectStmt {
    bool getAll;
    map<string, ColumnTypes> columns;
    string tableName;
    list<ColumnComparison> conditions;

};

typedef struct QueryStmt {
    QueryCommands queryCmd;
    CreateDatabaseStmt databaseStmt;
    CreateTableStmt createTableStmt;
};

////struct SelectStmt {
////    bool getAll;
////    map<string, ColumnTypes> m;
////};
//
////struct Query {
////    QueryCommands queryType;
////
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

#endif //TEST_BISON_QUERY_H
