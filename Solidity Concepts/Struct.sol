// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
struct - user define datatype
They are useful for grouping together related data.
can be declared outside of a contract and imported in another contract.
*/

contract Structure{
    struct userStruct{
        string name;
        uint age;
        address accountAdd;
        bool boy;
    }  

    userStruct[] public Users;

    function func1(string memory _name, uint _age, bool _boy) external{
        Users.push(userStruct(_name, _age, msg.sender, _boy));
    }

    function func2(string memory _name, uint _age, bool _boy) external{
        Users.push(userStruct({name: _name, age: _age, accountAdd: msg.sender, boy: _boy}));
    }
}