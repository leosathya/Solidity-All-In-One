// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. 4 ways to send Ether to a Contract
. transfer (2300 gas, throws error)
. send (2300 gas, returns bool)
. call (Recommended)  (forward all gas or set gas, returns bool)
. selfdestruct (forcefully sending ether to a contract)

. 2 ways to receive Ether by Contract
. receive() external payable
. fallback() external payable

. receive() is called if msg.data is empty, 
. fallback() is called if msg.data present or receive() isn't present

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()

*/

contract ReceivingEth{
    function getBalance() external view returns(uint bal){
        bal = address(this).balance;
    }
    receive() external payable{}
    fallback() external payable{}
}

contract sendingEth{
    address payable public receiveContract;

    constructor(address _add){
        receiveContract = payable(_add);
    }
    function sendViaTransfer() external payable{
        receiveContract.transfer(msg.value);
    }
    function sendViaSend() external payable{
        bool sent = receiveContract.send(msg.value);
        require(sent, "Tx Successfull.");
    }
    function sendViaCall() external payable{
        (bool sent, bytes memory data) = receiveContract.call{value: msg.value}("");
        require(sent, "Tx Successfull.");
    }
}

contract EmptyContract{
    function getBalance() external view returns(uint bal){
        bal = address(this).balance;
    }
}

contract ForceSending{
    address payable public emptyContract;
    constructor(address _cont){
        emptyContract = payable(_cont);
    }
    function getBalance() external view returns(uint bal){
        bal = address(this).balance;
    }
    function sendViaCall() external payable{
        (bool sent, ) = address(this).call{value: msg.value}("");
        require(sent, "Tx Successfull.");
    }
    function destroy() external{
        selfdestruct(emptyContract);
    }
    fallback() external payable{}
}