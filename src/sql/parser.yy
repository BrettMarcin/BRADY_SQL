%skeleton "lalr1.cc"
%require "3.4"
%defines
%define api.token.raw
%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires{
    #include <stdio.h>

    #include "../../../include/sql/Query.h"
    #include <list>
    #include <vector>

    using namespace std;
    class Driver;
    class TypeName;
    class Node;

}

%param { Driver& drv }
%locations

%code {
    #include "../Driver.hh"
}

%define parse.trace
%define parse.error detailed
%define parse.lac full
%define api.token.prefix {TOK_}

%nterm <Node*> stmt CreateStmt columnDef

%nterm <std::list<Node*>*> TableElement TableElementList OptTableElementList

%token <std::string> ColId IDENTIFIER "identifier"
%nterm <TypeName*> SimpleTypename Numeric CharacterWithLength Character
%token <int> NUM "number"

%token CREATE VARCHAR TABLE INT

%token LPAREN "("
        RPAREN ")"
        SEMI ";"
        COMMA ","
        CREATE "CREATE"
        VARCHAR "VARCHAR"
        TABLE "TABLE"
        INT "INT"

%%

%start startPt;

startPt:
        %empty  {}
        | stmts
        ;

stmts: stmt ";"
    {
        drv.res = 1;
        drv.result = $1;
    }
    ;

stmt:
    CreateStmt
    ;

CreateStmt: "CREATE" "TABLE" "identifier" "(" OptTableElementList ")"
		{
			CreateStmt* createStmt = new CreateStmt(T_CreateStmt);
			createStmt->setTableElementsList($5);
			createStmt->setTableName($3);

			$$ = (Node *)createStmt;
		}
		;


// TODO: add empty rule
OptTableElementList:
	TableElementList { $$ = $1; }
	;

TableElementList:
		TableElement
			{
				$$ = $1;
			}
		| TableElementList "," TableElement
			{
				std::list<Node*>* listWithAll = $1;
				std::list<Node*>* otherList = $3;
				std::list<Node*> listWithAllPtr = *otherList;
				for (const auto& item : listWithAllPtr) {
					listWithAll->push_back(item);
				}
				$$ = listWithAll;

			}
		;

//
TableElement:
	columnDef {
		std::list<Node*>* listPtr = new std::list<Node*>();
		listPtr->push_back($1);
		$$ = listPtr;
	}
	;

// TODO: fill out class with results
// TODO: need to redo the identifer
columnDef: "identifier" SimpleTypename {
			ColumnDef* col = new ColumnDef(T_ColumnDef);
			col->setColName($1);
			col->setType($2);
			$$ = (Node *)col;
		}
	;

SimpleTypename:
    Numeric { $$ = $1; }
	| Character { $$ = $1; }
	;

Numeric:
	"INT" { $$ = new TypeName(T_INT); }
	;

Character: CharacterWithLength {
		$$ = $1;
	}
	;

// TODO: get value of constant
CharacterWithLength:  "VARCHAR" "(" "number" ")"
				{
					VarCharTypeName* typeName = new VarCharTypeName(T_VARCHAR);
					$$ = (TypeName*)typeName;
				}
				;
%%

void
yy::parser::error (const location_type& l, const std::string& m)
{
  std::cerr << l << ": " << m << '\n';
}
