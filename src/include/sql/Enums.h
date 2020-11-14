//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#ifndef TEST_BISON_ENUMS_H
#define TEST_BISON_ENUMS_H

typedef enum NodeTag
{
    T_Query,
    T_SelectStmt,
    T_CreateTableStmt,
    T_DatabaseStmt,
    T_InsertStmt,
    T_ColumnDef
};

typedef enum ColType
{
    T_INT,
    T_VARCHAR
};

typedef enum CompareOperation
{
    T_EQ,
    T_N_EQ,
    T_GE,
    T_LE,
    T_LE_EQ,
    T_GE_EQ,
    T_IDENTIFIER,
    T_IS,
    T_AND,
    T_NOT,
    T_OR
};

typedef enum Generic{
    T_STRING,
    T_NUMBER
};

#endif //TEST_BISON_ENUMS_H
