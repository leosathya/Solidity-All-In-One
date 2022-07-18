// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A{
    uint public num;
    function setNum(uint _n) external returns(uint){
        num = _n;
        return num;
    }
    function setNumByPay(uint _n) external payable returns(uint, uint){
        num = _n;
        return (num, msg.value);
    }
}

contract B{
    function callingSetNum(A _a, uint _n) external returns(uint){
       return _a.setNum(_n);
    }
    function callingSetNumPay(address _a, uint _n) external payable returns(uint a, uint b){
        (a, b) = A(_a).setNumByPay{value: msg.value}(_n);
    }
}