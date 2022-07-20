// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract MultiDelegateCall{
    error delegatecallFailed();

    function calling(bytes[] calldata data) external payable returns(bytes[] memory){
        bytes[] memory result = new bytes[](data.length);
        
        for(uint i; i<data.length; i++){
            (bool succ, bytes memory res) = address(this).delegatecall(data[i]);
            if(!succ){
                revert delegatecallFailed();
            } 
            result[i] = res;
        }
        return result;
    }
}

contract TestMultiDelegateCall is MultiDelegateCall{
    event Log(address caller, string funcName, uint res);
    mapping(address => uint) public balanceOf;

    function func1(uint _a , uint _b) external  {
        emit Log(msg.sender, "func1", _a+_b);
    }
    function func2() external  {
        emit Log(msg.sender, "func2", 2);
    }

    /* Can be dangereous */
    function mint()external payable{
        balanceOf[msg.sender] += msg.value;
    }

    /*   When you call 2 times this uing calling function, although you send 1eth, but as context is
         reserve in deligate call so, shown balance will be 2eth  */
}


contract Encoder{
    function encodingFunc1(uint _a , uint _b) external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, _a, _b);
    }
    function encodingFunc2() external pure returns(bytes memory) {
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    }
    function encodingMinting() external pure returns(bytes memory){
        return abi.encodeWithSelector(TestMultiDelegateCall.mint.selector);
    }
}