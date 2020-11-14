%skeleton "lalr1.cc"
%require "3.4"
%defines
%define api.token.raw
%define api.token.constructor
%define api.value.type variant
%define parse.assert

%code requires{
    #include <stdio.h>

    #include "../../include/Query.h"
    #include <list>
    #include <vector>
    #include "../../include/NodeTree.h"
    #include "../../include/CompareOpt.h"
    #include "../../include/sql/SelectStmt.h"
    #include "../../include/sql/Enums.h"

    using namespace std;
    class Driver;
    class TypeName;
    class Node;
    class NodeTree;
    class CompareOpt;

}

%param { Driver& drv }
%locations

%code {
    #include "../../include/sql/Driver.hh"
}

%define parse.trace
%define parse.error detailed
%define parse.lac full
%define api.token.prefix {TOK_}

%nterm <Node*> stmt CreateStmt columnDef CreateTable CreateDatabase query_specification query_expression select_stmt select_item_list_opt

%nterm <std::list<Node*>*> TableElement TableElementList OptTableElementList

%token <std::string> ColId IDENTIFIER "identifier"
%nterm <TypeName*> SimpleTypename Numeric CharacterWithLength Character
%token <int> NUM "number"
%nterm <CompareOpt*> comp_op
%nterm <NodeTree*> expr where_clause opt_where_clause
%nterm <std::list<std::string>*> select_item select_item_list
%nterm <std::string> from_clause

%token LPAREN "("
        RPAREN ")"
        SEMI ";"
        COMMA ","
        STAR "*"
        CREATE "CREATE"
        VARCHAR "VARCHAR"
        TABLE "TABLE"
        INT "INT"
        DATABASE "DATABASE"
        SELECT "SELECT"
        FROM "FROM"
        WHERE "WHERE"
        AND "AND"
        OR "OR"
        EQ "=="
        N_EQ "!="
        GE ">"
        LE "<"
        GE_EQ ">="
        LE_EQ "<="
        IS "IS"
        FALSE "FALSE"
        TRUE "TRUE"
        NOT "NOT"

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
    CreateTable
    | CreateDatabase
    | select_stmt
    ;

CreateTable: "CREATE" "TABLE" "identifier" "(" OptTableElementList ")"
		{
			CreateTableStmt* createStmt = new CreateTableStmt(T_CreateTableStmt);
			createStmt->setTableElementsList($5);
			createStmt->setTableName($3);

			$$ = (Node *)createStmt;
		}
		;

CreateDatabase: "CREATE" "DATABASE" "identifier"
                {
                    CreateDatabaseStmt* database = new CreateDatabaseStmt(T_DatabaseStmt);
                    database->setDatabaseName($3);
                    $$ = (Node *)database;
                }
                ;

// TODO: with parens
select_stmt:
        query_expression {
            $$ = $1;
        }
        ;

query_expression:
                query_specification {
                    $$ = $1;
                }
                ;

query_specification:
                "SELECT" select_item_list_opt from_clause opt_where_clause {
                    SelectStmt* selectSmt = (SelectStmt*)$2;
                    selectSmt->setFromClause($3);
                    selectSmt->setNodeTree($4);
                    $$ = (Node*)selectSmt;
                }
                ;

select_item_list_opt:
            "*" {
                SelectStmt* theNode = new SelectStmt(T_SelectStmt);
                theNode->setSelectAll(true);
                $$ = (Node*)theNode;
            }
            | select_item_list {
                SelectStmt* theNode = new SelectStmt(T_SelectStmt);
                theNode->setTargetList($1);
                $$ = (Node*)theNode;
            }
            ;

select_item_list:
            select_item {
                $$ = $1;
            }
            | select_item_list "," select_item {
                std::list<std::string>* listWithAll = $1;
                std::list<std::string>* otherList = $3;
                std::list<std::string> listWithAllPtr = *otherList;
                  for (const auto& item : listWithAllPtr) {
                      listWithAll->push_back(item);
                  }
                  $$ = listWithAll;
            }
            ;

// TODO: add for alias'
select_item:
        "identifier" {
            list<std::string>* theList = new list<std::string>();
            theList->push_back($1);
            $$ = theList;
        }
        ;



from_clause: "FROM" "identifier" {
                $$ = $2;
            }
            ;

opt_where_clause:
            %empty { $$ = nullptr; }
            | where_clause
            ;

where_clause:
            "WHERE" expr { $$ = $2; }
            ;

expr:
            expr "OR" expr {
                CompareOpt* opt = new CompareOpt(T_OR);
                NodeTree* node = new NodeTree(opt);
                NodeTree* left = (NodeTree*)$1;
                NodeTree* right = (NodeTree*)$3;
                node->setLeft(left);
                node->setRight(right);
                $$ = node;
            }
            | expr "AND" expr {
                CompareOpt* opt = new CompareOpt(T_AND);
                NodeTree* node = new NodeTree(opt);
                NodeTree* left = (NodeTree*)$1;
                NodeTree* right = (NodeTree*)$3;
                node->setLeft(left);
                node->setRight(right);
                $$ = node;
            }
            | "NOT" expr {
                CompareOpt* opt = new CompareOpt(T_NOT);
                NodeTree* node = new NodeTree(opt);


                node->setRight($2);
                node->setLeft(NULL);
                $$ = node;
            }
            | expr comp_op expr {
                NodeTree* node = new NodeTree($2);
                NodeTree* left = (NodeTree*)$1;
                NodeTree* right = (NodeTree*)$3;
                node->setLeft(left);
                node->setRight(right);
                $$ = node;
            }
            | expr "IS" "TRUE" {
                CompareOpt* opt = new CompareOpt(T_IS);
                CompareOpt* opt2 = new CompareOpt(T_IDENTIFIER);
                opt2->setTheId("TRUE");
                opt->setBool(true);
                NodeTree* node = new NodeTree(opt);
                NodeTree* rightNode = new NodeTree(opt);
                node->setRight(rightNode);
                node->setLeft($1);
                $$ = node;
            }
            | expr "IS" "FALSE"{
                CompareOpt* opt = new CompareOpt(T_IS);
                CompareOpt* opt2 = new CompareOpt(T_IDENTIFIER);
                opt2->setTheId("FALSE");
                opt->setBool(false);
                NodeTree* node = new NodeTree(opt);
                NodeTree* right = new NodeTree(opt);
                node->setRight(right);
                node->setLeft($1);
                $$ = node;
            }
            |

            | "identifier" {
                CompareOpt* opt = new CompareOpt(T_IDENTIFIER);
                opt->setTheId($1);
                NodeTree* node = new NodeTree(opt);
                $$ = node;
            }
            ;

comp_op:
          "=="     { $$ = new CompareOpt(T_EQ); }
        | "!=" { $$ = new CompareOpt(T_N_EQ); }
        | ">"     { $$ = new CompareOpt(T_GE); }
        | "<" { $$ = new CompareOpt(T_LE); }
        | ">="     { $$ = new CompareOpt(T_LE_EQ); }
        | "<="     { $$ = new CompareOpt(T_GE_EQ); }
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
