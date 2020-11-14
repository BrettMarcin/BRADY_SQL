//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#ifndef TEST_BISON_COMPAREOPT_H
#define TEST_BISON_COMPAREOPT_H

#include <string>
#include "sql/Enums.h"

using namespace std;

class CompareOpt {
public:
    CompareOpt(CompareOperation compareOpt);

    void setTheId(string theId);
    void setBool(bool setBoolVariable);
protected:
    CompareOperation compareOpt;
    bool setBoolVariable;
    string theId;
};


#endif //TEST_BISON_COMPAREOPT_H
