//
// Created by Brett Marcinkiewicz on 11/12/20.
//

#include "Driver.hh"
#include "build_files/parser.hh"

Driver::Driver() {
    res = 0;
}

int
Driver::parse (char* stringInput)
{
    this->stringInput = stringInput;
    scan_begin ();
    yy::parser parse (*this);
    int res = parse();
    return res;
}
