// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
. when intende to call 2 different function at same time at same block.timestamp
*/

contract TestingMultiCall{
    function f1(uint _num, string calldata _s) external view returns(uint , string memory, uint){
        return (_num, _s, block.timestamp);
    }
    function f2(uint _num, string calldata _s) external view returns(uint, string memory, uint){
        return (_num, _s, block.timestamp);
    }

    // making Signatures
    function makeDataF1(uint _num, string calldata _s) external pure returns(bytes memory){
        // both are same
        //return abi.encodeWithSignature("f1(uint256, string)", _num, _s);
        return abi.encodeWithSelector(this.f1.selector, _num, _s);
    }
    function makeDataF2(uint _num, string calldata _s) external pure returns(bytes memory){
        // both are same
        return abi.encodeWithSignature("f1(uint256, string)", _num, _s);
        //return abi.encodeWithSelector(this.f1.selector, _num, _s);
    }

    function f3() external view returns(uint , string memory, uint){
        return (1, "sas", block.timestamp);
    }
    function f4() external view returns(uint, string memory, uint){
        return (2, "sas", block.timestamp);
    }

    // making Signatures
    function makeDataF3() external pure returns(bytes memory){
        // both are same
        //return abi.encodeWithSignature("f1(uint256, string)", _num, _s);
        return abi.encodeWithSelector(this.f3.selector);
    }
    function makeDataF4() external pure returns(bytes memory){
        // both are same
        return abi.encodeWithSignature("f4()");
        //return abi.encodeWithSelector(this.f1.selector, _num, _s);
    }
}

contract Multicall{
    function multiiCalling1(address add, bytes[] calldata data) external view returns(bytes[] memory){
        bytes[] memory result = new bytes[](data.length);

        for(uint i; i<data.length; i++){
            (bool succ, bytes memory res) = add.staticcall(data[i]);
            require(succ, "Static call failed");
            result[i] = res;
        }

        return result;
    }

    function multiiCalling2(address add, bytes[] calldata data) external view returns(bytes[] memory){
        bytes[] memory result = new bytes[](data.length);

        for(uint i; i<data.length; i++){
            (bool succ, bytes memory res) = add.staticcall(data[i]);
            require(succ, "Static call failed");
            result[i] = res;
        }

        return result;
    }
}