//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#ifndef TEST_BISON_SELECTSTMT_H
#define TEST_BISON_SELECTSTMT_H

#include "../Query.h"

class SelectStmt : public Node {
public:
    SelectStmt(NodeTag type) : Node(type) {
        selectAll = false;
    }
    void setTargetList(list<string>* targetList) {
        this->targetList = targetList;
    }
    void setSelectAll(bool selectAll) {
        this->selectAll = selectAll;
    }
    void setNodeTree(NodeTree* nodeTree) {
        this->nodeTree = nodeTree;
    }
    void setFromClause(string fromClause) {
        this->fromClause = fromClause;
    }
protected:
    list<string>    *targetList;
    string          fromClause;
    bool            selectAll;
    Node	        *whereClause;
    NodeTree*       nodeTree;
};

#endif //TEST_BISON_SELECTSTMT_H
