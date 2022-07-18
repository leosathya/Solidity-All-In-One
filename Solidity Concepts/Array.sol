// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Array{
    uint[] public arr1;

    constructor(){}

    function addToArr(uint _num) external {
        arr1.push(_num);
    }
    function popToArr() external {
        arr1.pop();
    }
    function removeFromIdx(uint _idx) external {
        delete arr1[_idx]; // Not delete that index, only it reset that to default value. 
    }
    function readArr() external view returns(uint[] memory ){
        return arr1;
    }
    function examples() external pure{
        // create array in memory, only fixed size can be created
        uint[] memory a = new uint[](5);
    }
}