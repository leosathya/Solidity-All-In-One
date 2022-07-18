// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Inc{
    /*
    . cannot have any functions implemented (Only Signature)
    . can inherit from other interfaces (if use contract can't able)
    . all declared functions must be external
    . no constructor
    . no state variables
    */

    function Counter(uint num) external pure returns(uint n){
        n = num + 1;
    }
}

interface IInc{
    function Counter(uint num) external pure returns(uint n);
}

contract CallCounter{
    function Calling(address _add, uint _num) external pure returns(uint ){
        return IInc(_add).Counter(_num);
    }
}