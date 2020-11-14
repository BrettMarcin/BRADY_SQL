%{
    #include <stdio.h>
    #include <string.h>
    #include "parser.hh"
    #include "../../include/Query.h"
    #include <list>
    #include <vector>

    #include "../../include/sql/Driver.hh"
    #include "../../include/NodeTree.h"
    #include "../../include/CompareOpt.h"
%}

%option noyywrap
%option nounput noinput
%option batch
%option debug

%{
  // A number symbol corresponding to the value in S.
  yy::parser::symbol_type
  make_NUM (const std::string &s, const yy::parser::location_type& loc);
%}

int     ([0-9])+
alpha       ([a-zA-Z])+

%{
  // Code run each time a pattern is matched.
  # define YY_USER_ACTION  loc.columns (yyleng);
%}

%%
%{
  // A handy shortcut to the location held by the driver.
  yy::location& loc = drv.location;
  // Code run each time yylex is called.
  loc.step ();
%}

\n+        loc.lines (yyleng); loc.step ();
"(" return yy::parser::make_LPAREN(loc);
")" return yy::parser::make_RPAREN(loc);
";" return yy::parser::make_SEMI(loc);
"," return yy::parser::make_COMMA(loc);
"*" return yy::parser::make_STAR(loc);
"'" return yy::parser::make_APOS(loc);
"CREATE" return yy::parser::make_CREATE(loc);
"VARCHAR" return yy::parser::make_VARCHAR(loc);
"INT" return yy::parser::make_INT(loc);
"TABLE" return yy::parser::make_TABLE(loc);
"DATABASE" return yy::parser::make_DATABASE(loc);
"SELECT" return yy::parser::make_SELECT(loc);
"FROM" return yy::parser::make_FROM(loc);
"WHERE" return yy::parser::make_WHERE(loc);
"AND" return yy::parser::make_AND(loc);
"OR" return yy::parser::make_OR(loc);
"INSERT" return yy::parser::make_INSERT(loc);
"INTO" return yy::parser::make_INTO(loc);
"SET" return yy::parser::make_SET(loc);
"=" return yy::parser::make_SET_EQ(loc);
"==" return yy::parser::make_EQ(loc);
"!=" return yy::parser::make_N_EQ(loc);
">" return yy::parser::make_GE(loc);
"<" return yy::parser::make_LE(loc);
">=" return yy::parser::make_GE_EQ(loc);
"<=" return yy::parser::make_LE_EQ(loc);
"IS" return yy::parser::make_IS(loc);
"FALSE" return yy::parser::make_FALSE(loc);
"TRUE" return yy::parser::make_TRUE(loc);
"NOT" return yy::parser::make_NOT(loc);
{int} return make_NUM(yytext, loc);
{alpha} return yy::parser::make_IDENTIFIER(yytext, loc);
<<EOF>>    return yy::parser::make_YYEOF (loc);
%%

yy::parser::symbol_type
make_NUM (const std::string &s, const yy::parser::location_type& loc)
{
  errno = 0;
  long n = strtol (s.c_str(), NULL, 10);
  if (! (INT_MIN <= n && n <= INT_MAX && errno != ERANGE))
    throw yy::parser::syntax_error (loc, "integer is out of range: " + s);
  return yy::parser::make_NUM ((int) n, loc);
}

void
Driver::scan_begin ()
{
  yy_scan_string(stringInput);
}

void
Driver::scan_end ()
{
  yy_delete_buffer(YY_CURRENT_BUFFER);
}