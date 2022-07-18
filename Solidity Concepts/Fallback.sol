// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
.fallback is a function that does not take any arguments and  return nothing.
.It is executed 2 way
    -> a function that does not exist is called or
    -> Ether is sent directly to a contract but receive() does not exist or msg.data is not empty
*/

contract ReceiveContract{
    event Log(uint gas);

    fallback() external payable{
        emit Log(gasleft());
    }
}

contract SendingContract{
    address payable public add;
    constructor(address _add){
        add = payable(_add);
    }
    function sendEth1() external payable {
        (bool sent, ) = add.call{value: msg.value}("");
        require(sent, "Tx Failed");
    }
    function sendEth2() external payable{
        bool sent = add.send(msg.value);
        require(sent, "Tx Failed");
    }
    function sendEth3() external payable{
        add.transfer(msg.value);
    }

    function callFun(string memory _s) external {
        (bool calling, ) = add.call(abi.encodeWithSignature("notExist(string, uint256)", _s, 111));
        require(calling, "Call Failed");
    }
}