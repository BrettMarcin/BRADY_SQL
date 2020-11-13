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
    #include <list>
    #include <vector>

    using namespace std;

    #define YYSTYPE int
    extern YYSTYPE yyltype

%}

// %union {
//     Expression exp;
// }

// %token UNKNOWN
// %token <i_type> NUMBER
// %token <c_type> ; ( ) ,
// %token <s_type> SELECT CREATE DATABASE column_name from table_name TABLE AND OR VARCHAR
// %token SELECT CREATE DATABASE column_name FROM table_name TABLE AND OR VARCHAR

//%token SEMICOLON SELECT L_PAR CREATE R_PAR DATABASE TABLE COMMA INT VARCHAR STRING NUM EVERYTHING

//%type <name> STRING qualified_name
//%type <number> NUM

%type <node> stmts stmt CreateStmt columnDef

%type <listnodes> TableElement TableElementList OptTableElementList

%type <str> ColId IDENT STRING
%type <keyword> col_name_keyword
%type <theTypeName> SimpleTypename Numeric CharacterWithLength Character
%type <ival> NUM

%token CREATE VARCHAR IDENT TABLE INT STRING NUM

//%union{
//	char		*str;
//    	class Node* node;
//    	const char* keyword;
//    	class TypeName* theTypeName;
//    	int		ival;
//    	vector<Node>* listnodes;
//}

//%parse-param {core_yyscan_t yyscanner}

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

//prog:
//    stmts
//;
/* for now only accept one statment */
stmts: stmts ';' stmt
    | stmt
    {
	if ($1 != NULL)
		$$ = $1;
	else
		$$ = NULL;
    }

stmt:
    CreateStmt
    ;

CreateStmt: CREATE TABLE STRING '(' OptTableElementList ')'
		{
			CreateStmt* createStmt = new CreateStmt(T_CreateStmt);
			createStmt->setTableElementsList($5);

			$$ = (Node *)createStmt;
		}
		;

OptTableElementList:
	TableElementList { $$ = $1}
	|	/*EMPTY*/ { $$ = NULL; }

TableElementList:
		TableElement
			{
				$$ = $1;
			}
		| TableElementList ',' TableElement
			{
				std::list<Node>* listWithAll = $1;
				std::list<Node>* otherList = $3;
				std::list<Node> listWithAllPtr = *otherList;
				for (const auto& item : listWithAllPtr) {
					listWithAll->push_back(item);
				}
				$$ = listWithAll;

			}
		;

//
TableElement:
	columnDef {
		std::list<Node>* listPtr = new std::list<Node>;
		listPtr->push_back($1);
		$$ = listPtr;
	}

// TODO: fill out class with results
columnDef: ColId SimpleTypename{
			ColumnDef* col = new ColumnDef(T_ColumnDef);
			$$ = (Node *)col;
		}
	;

// create a custome function to do lookup
ColId:
	STRING {		printf($1);
               			$$ = NULL;}
//	col_name_keyword {
//			printf($1);
//			$$ = NULL;
//			}
//	;

col_name_keyword:
	VARCHAR
	| INT
;

SimpleTypename:
	Character { $$ = $1; }
	| Numeric { $$ = $1; }

Numeric:
	INT { $$ = new TypeName(T_INT); }

Character: CharacterWithLength {
		$$ = $1;
	}
	;

// TODO: get value of constant
CharacterWithLength:  VARCHAR '(' NUM ')'
				{
					VarCharTypeName* typeName = new VarCharTypeName(T_VARCHAR);
					$$ = (TypeName*)typeName;
				}
		;


//create_table_exp:
//    declare_col {
//
//    }
//
//declare_col:
//    type_col STRING COMMA declare_col{
//    query.createTableStmt.columns.insert(std::pair<string,ColumnTypes>($2, $1));
////    colNameCache = $2;
////	if (cache == INT_TYPE) {
////		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,INT_TYPE));
////	} else if (cache == VARCHAR_TYPE) {
////		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,VARCHAR_TYPE));
////	}
//    }
//    | type_col STRING {
////    string name = $2;
//    	query.createTableStmt.columns.insert(std::pair<string,ColumnTypes>($2, $1));
//    	mymap.insert ( std::pair<char,int>('a',100) );
////    	colNameCache = $2;
////    	if (cache == INT_TYPE) {
////    		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,INT_TYPE));
////    	} else if (cache == VARCHAR_TYPE) {
////		query.createTableStmt.columns.insert(pair<string,ColumnTypes>($2,VARCHAR_TYPE));
////    	}
//    }
//
//type_col:
//    INT {
//    $$ = INT_TYPE;
////    query.createTableStmt.columnTypes.push_back (INT_TYPE);
////        query.createTableStmt.columns.insert(pair<string,ColumnTypes>(colNameCache,INT_TYPE));
//    }
//    |
//    VARCHAR L_PAR NUM R_PAR{
//    $$ = VARCHAR_TYPE;
////    	query.createTableStmt.columnTypes.push_back (VARCHAR_TYPE);
////    	query.createTableStmt.columns.insert(pair<string,ColumnTypes>(colNameCache,VARCHAR_TYPE));
//    }

%%
