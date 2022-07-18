// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. call = is a low level function
. used to send Eth to other contract or EOA
. to calling other contract function 

*/
contract ContractB{
    event Received(address caller, uint amount, string message);

    function funB(string memory _s) external pure returns(string memory){
        return _s;
    }
    function funC(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }
}

contract ContractA{
    event Response(bool success, bytes data);

    function callFunB(address _add, string memory _s)public payable{
        (bool call, ) = _add.call(abi.encodeWithSignature("funB(string)", _s));
        require(call, "call failed");

         // You can send ether and specify a custom gas amount
        (bool success, bytes memory data) = _add.call{value: msg.value, gas: 5000}(
            abi.encodeWithSignature("funC(string,uint256)", "call foo", 123)
        );

        emit Response(success, data);
    }

   
}

