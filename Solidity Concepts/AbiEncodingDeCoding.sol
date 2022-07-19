// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract EncodingDecoding{
    struct User{
        string name;
        uint age;
        string[2] projects;
    }

    function encoding(uint _slNo, string calldata _name, User calldata _user) external pure returns(bytes memory){
        return abi.encode(_slNo, _name, _user);
    }

    function decoding(bytes calldata _data) external payable returns(uint _slNo, string memory _name, User memory _user){
        (_slNo,_name, _user) = abi.decode(_data, (uint, string, User));
    }
}