//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#ifndef TEST_BISON_NODETREE_H
#define TEST_BISON_NODETREE_H

#include "../include/sql/Query.h"
#include "CompareOpt.h"

class NodeTree {
    public:
        NodeTree(CompareOpt* item);
        void setLeft(NodeTree* left);
        void setRight(NodeTree* setRight);
        void setItem(CompareOpt* item);
    protected:
        NodeTree* left;
        NodeTree* right;
        CompareOpt* item;

};


#endif //TEST_BISON_NODETREE_H
