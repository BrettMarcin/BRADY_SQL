//
// Created by Brett Marcinkiewicz on 11/13/20.
//

#include "include/NodeTree.h"

NodeTree::NodeTree(CompareOpt* item) {
    this->item = item;
    left = NULL;
    right = NULL;
}

void NodeTree::setLeft(NodeTree* left) {
    this->left = left;
}

void NodeTree::setRight(NodeTree* right) {
    this->right = right;
}

void NodeTree::setItem(CompareOpt* item) {
    this->item = item;
}