// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. Error undo all changes made during the transaction
. 4 Types

1. require
2. revert - internally use require
3. assert - specially used to check those errors which we intendent to not occure
4. customeError
*/

contract Errors{
    address public owner;

    constructor(){}

    error NumberLessThan5();

    function func1(uint _num) external pure{
        require(_num > 5, "Number is less than 5.");
    }
    function func2(uint _num) external pure{
        if(_num < 5){
            revert("Number is less than 5.");
        }
    }
    function func3() external view{
        assert(owner == address(0));
    }
    function func4(uint _num) external pure{
        if(_num < 5){
            revert NumberLessThan5();
        }
    } 
}