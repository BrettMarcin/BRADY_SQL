//
// Created by Brett Marcinkiewicz on 11/12/20.
//

#include "Driver.hh"
#include "build_files/parser.hh"

Driver::Driver() {
    res = 0;
}

int
Driver::parse (const std::string &f)
{
    file = f;
    location.initialize (&file);
    scan_begin ();
    yy::parser parse (*this);
    int res = parse ();
    return res;
}
