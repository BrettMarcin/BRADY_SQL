//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#include "include/CompareOpt.h"


CompareOpt::CompareOpt(CompareOperation compareOpt) {
    this->compareOpt = compareOpt;
    this->setBoolVariable = false;
}

void CompareOpt::setTheId(string theId) {
    this->theId = theId;
}

void CompareOpt::setBool(bool setBoolVariable) {
    this->setBoolVariable = setBoolVariable;
}