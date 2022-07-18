// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. useful to model choice and keep track of state
. can be declared outside of a contract.
*/
contract Enum{
    enum Phases{
        off,
        free,
        earlyBackersSale,
        preSale,
        publicSale,
        paused
    }
    
    Phases public contractPhase;

    constructor(){
        contractPhase = Phases.off;
    }

    function changeState(Phases _state) external{
        contractPhase = _state;
    }
}