// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. Its way to catch attackers
. Show that your contract is Vulnerable to some type of Contract Hacks
. Hide the contract code that will able to catch them
. When they try to hack your contract, expose them

. Here im going to use a contract that Vulnerable to Phising attack with tx.origin
*/

contract A{
    address payable public owner;
    LoggingWithdraw lw;


    event Log(address sender, uint value);

    modifier onlyOwner{
        require(owner == tx.origin, "Only owner");
        _;
    }

    receive() external payable{
    
    }

    constructor(address _lw){
        owner = payable(msg.sender);
        lw = LoggingWithdraw(_lw);
    }

    function deposit() public payable{
        emit Log(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner{
        lw.log(msg.sender);
        (bool succ, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(succ, "Tx Failed");
    }

    function balance() external view returns (uint){
        return address(this).balance;
    }
}
contract LoggingWithdraw{
    address private ownerOfA;

    event Log(string msg, address withdrawer);
    constructor(){
        ownerOfA = msg.sender;
    }

    function log(address _add) external {
        emit Log("withdrawer Address :: ", _add);
    }
}

contract CatchHacker{
    address private ownerOfA;

    event Log(string hackerMsg, address hacker);
    constructor(){
        ownerOfA = msg.sender;
    }

    function log(address _add) external {
        emit Log("Hacker Address :: ", _add);
        require(_add == ownerOfA, "Someone trying to Hack Contract");
        
    }
}

contract Hacker{
    A add;

    constructor(A _add){
        add = A(_add);
    }
    receive() external payable{}

    function attack() external{
        add.withdraw();
    }

    function balance() external view returns (uint){
        return address(this).balance;
    }
}