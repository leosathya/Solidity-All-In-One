// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. In Solidity any address can be casted into specific contract,
 even if the contract at the address is not the one being casted.
*/

contract A{
    B b;
    constructor(address _b){ // actually i'm going to pass here Address of C instead of B
        b = B(_b);
    }

    function log() external {
        b.callinngLog(); 
    }
}

// let i make a proper contract and a mallicious contract
// im showing that im using pure contract but under the hood
// instead of using contractB address in A i use malicious contract C address to do some Phisy

// so always throughly check addresses of deployed contract and their code
// when one contract calling other
contract B{
    event LogMsg(string msg);
    function callinngLog() external {
        emit LogMsg("Msg from ContractB");
    }
}

contract C{
    event LogMsg(string msg);
    function callinngLog() external {
        emit LogMsg("Msg from Mallicious Contract");
    }
}