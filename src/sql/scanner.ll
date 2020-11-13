%{
    #include <stdio.h>
    #include <string.h>
    #include "parser.hh"
    #include "../../../include/sql/Query.h"
    #include <list>
    #include <vector>

    #include "../Driver.hh"
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
blank [ \t\r]

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

{blank}+   loc.step ();
\n+        loc.lines (yyleng); loc.step ();
"(" return yy::parser::make_LPAREN(loc);
")" return yy::parser::make_RPAREN(loc);
";" return yy::parser::make_SEMI(loc);
"," return yy::parser::make_COMMA(loc);
"CREATE" return yy::parser::make_CREATE(loc);
"VARCHAR" return yy::parser::make_VARCHAR(loc);
"INT" return yy::parser::make_INT(loc);
"TABLE" return yy::parser::make_TABLE(loc);
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
  if (file.empty () || file == "-")
    yyin = stdin;
  else if (!(yyin = fopen (file.c_str (), "r")))
    {
      std::cerr << "cannot open " << file << ": " << strerror (errno) << '\n';
      exit (EXIT_FAILURE);
    }
}

void
Driver::scan_end ()
{
  fclose (yyin);
}