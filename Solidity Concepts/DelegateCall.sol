// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. delegateCall = is a low level function
. when contract A delegateCall to contract B, 
. it simply says B that run your function using my storage 

. storage variable orders must be same in both contract 
*/
contract ContractB{
    uint public num;
    address public caller;
    uint public eth;

    function changeVar(uint _num) public payable{
        num = _num;
        caller = msg.sender;
        eth = msg.value;
    }
}

contract ContractA{
    uint public num;
    address public caller;
    uint public eth;

    function callB(address _add, uint _num)public payable{
        (bool sent, bytes memory data) = _add.delegatecall(
            abi.encodeWithSignature("changeVar(uint256)", _num));
        require(sent, "Tx Failed");
    }
}