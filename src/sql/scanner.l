%{
    #include <stdio.h>
    #include <string.h>
    #include "tokens.h"
    #include "../../../include/sql/Query.h"
%}

numbers     ([0-9])+
alpha       ([a-zA-Z])+

%option noyywrap
%%
";" {return (SEMICOLON);}
"(" {return (L_PAR);};
")" {return (R_PAR);}
"SELECT" {return (SELECT);}
"CREATE" {return (CREATE);}
"DATABASE" {return (DATABASE);}
"TABLE" {return (TABLE);}
"," {return (COMMA);}
"INT" {
        yylval.ColumnType = INT_TYPE;
        return (INT);}
"VARCHAR" {
            yylval.ColumnType = VARCHAR_TYPE;
            return (VARCHAR);}
"*" {return (EVERYTHING);}
{alpha}			   {sscanf(yytext, "%s", yylval.name); return (STRING);}
{numbers}      {yylval.number = atoi(yytext); return (NUM);}
%%

void scan_string(const char* str)
{
    yy_switch_to_buffer(yy_scan_string(str));
}
