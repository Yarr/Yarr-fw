/*
 * Authors: T. Heim <timon.heim@cern.ch>
 * Date: 2013-Oct-22
 */

#include "LoopEngine.h"

// Our LoopEngine will take care of distributing the global Fe to each loop item
LoopEngine::LoopEngine(Fei4 *fe, TxCore *tx, RxCore *rx) {
    g_fe = fe;
    g_tx = tx;
    g_rx = rx;
}

LoopEngine::~LoopEngine() {
}

// Add an item/loop to the engine
void LoopEngine::addAction(Engine::element_value_type el){
    m_list.push_back(el);
}

// Iniitialization step, needed before execution
void LoopEngine::init() {
    Engine::loop_list_type::iterator it = m_list.begin();
    while(m_list.end() != it) {
        stat.addLoop((*it).get());
        (*it)->setup(&stat, g_fe, g_tx, g_rx);
        ++it;
    }
}

// Execution of items/loops
void LoopEngine::execute() {
    Engine::execute(m_list);
}

// What has to be done after execution
void LoopEngine::end() {

}
