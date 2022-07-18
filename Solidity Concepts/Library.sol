// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. Libraries are similar to contracts, but you can't declare any state variable and can't send ether.
. Library used 2 ways
    -> A library is embedded into the contract if all library functions are internal.
    -> Otherwise the library must be deployed and then linked before the contract is deployed.
*/

library type1{
    function sum(uint _a, uint _b) internal pure returns(uint){
        return(_a + _b);
    }
}
library type2{
    function deletEle(uint[] storage arr, uint index) public{
        require(arr.length > 0, "Empty array");
        arr[index] = arr[arr.length-1];
        arr.pop();
    }
}

contract Library{
    using type1 for uint;
    using type2 for uint[];
    
    uint[] public arr;

    function addToArr(uint _num) external {
        arr.push(_num);
    }
    function removeEle(uint _idx) external{
        arr.deletEle(_idx);
    }
    function readArr()external view returns(uint[] memory){
        return arr;
    }
    
    // library calling style-1
    function add(uint _a, uint _b) external pure returns(uint sum){
        return type1.sum(_a,_b);
    }

    // library calling style-2
    function add2(uint _a, uint _b) external pure returns(uint sum){
        return _a.sum(_b);
    }
}