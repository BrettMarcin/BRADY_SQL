%{
    #include <stdio.h>
    void yyerror(const char* msg) {
        printf("error!");
      fprintf(stderr, "%s\n", msg);
   }
   int yylex();
    // #include "include/sql/Expression.h"

    // int yylex();
    // int yyerror(char *s);

    #include "../../../include/sql/Query.h"

    QueryStmt query;
    string colNameCache;
    int cahceValue = -1;

%}

// %union {
//     Expression exp;
// }

// %token UNKNOWN
// %token <i_type> NUMBER
// %token <c_type> ; ( ) ,
// %token <s_type> SELECT CREATE DATABASE column_name from table_name TABLE AND OR VARCHAR
// %token SELECT CREATE DATABASE column_name FROM table_name TABLE AND OR VARCHAR

%token SEMICOLON SELECT L_PAR CREATE R_PAR DATABASE TABLE COMMA INT VARCHAR STRING NUM EVERYTHING

%type <name> STRING
%type <number> NUM
%type <column_type> type_col

%union{
	 char name[20];
    	int number;
//    	ColumnTypes column_type;
}

// SELECT:
//     EVERYTHING {

//     }
//     | select_col {

//     }

// select_col:
//     STRING COMMA {

//     }
//     | STRING

// declare_col:
//     type_col STRING COMMA declare_col{
//         printf("\n Column name %s", $2);
//     }
//     | type_col STRING {
//         printf("\n Column name %s", $2);
//     }

%%

prog:
    stmts
;

stmts:
    | stmt SEMICOLON

stmt:
    CREATE create_stmt{
        printf("Will perform a create");
    }


create_stmt:
    TABLE STRING L_PAR create_table_exp R_PAR {
    	query.queryCmd = CREATE_TABLE_CMD;
    	query.createTableStmt.name = $2;
    }
    | DATABASE STRING {
    	query.queryCmd = CREATE_DATABASE_CMD;
    	query.databaseStmt.name = $2;
    }

create_table_exp:
    declare_col {

    }

declare_col:
    type_col STRING COMMA declare_col{
    query.createTableStmt.columns.insert(std::pair<string,ColumnTypes>($2, $1));
//    colNameCache = $2;
//	if (cache == INT_TYPE) {
//		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,INT_TYPE));
//	} else if (cache == VARCHAR_TYPE) {
//		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,VARCHAR_TYPE));
//	}
    }
    | type_col STRING {
//    string name = $2;
    	query.createTableStmt.columns.insert(std::pair<string,ColumnTypes>($2, $1));
    	mymap.insert ( std::pair<char,int>('a',100) );
//    	colNameCache = $2;
//    	if (cache == INT_TYPE) {
//    		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,INT_TYPE));
//    	} else if (cache == VARCHAR_TYPE) {
//		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,VARCHAR_TYPE));
//    	}
    }

type_col:
    INT {
    $$ = INT_TYPE;
//    query.createTableStmt.columnTypes.push_back (INT_TYPE);
//        query.createTableStmt.columns.insert(pair<string,ColumnTypes>(colNameCache,INT_TYPE));
    }
    |
    VARCHAR L_PAR NUM R_PAR{
    $$ = VARCHAR_TYPE;
//    	query.createTableStmt.columnTypes.push_back (VARCHAR_TYPE);
//    	query.createTableStmt.columns.insert(pair<string,ColumnTypes>(colNameCache,VARCHAR_TYPE));
    }

%%

QueryStmt return_ob() {
	return query;
}
