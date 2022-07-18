// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. private = only called inside parent contract that define function
. internal = called by parent and inherited contract functions
. public = can call by any contract and account
. external = call by other contract and accounts

. view = when function only read stateVariable
. pure =  ,,    ,,    doesn't read nor change stateVariable

// Data Location Type
. memory = variable is a state variable (store on blockchain)
. storage = variable is in memory and it exists while a function is being called
. calldata = special data location that contains function arguments
*/
contract FunctionVisibility{
    function func1() external pure returns(string memory){
        return "Its a external Function.";
    }
    function func2() public pure returns(string memory){
        return "Its a Public Function.";
    }
    function func3() internal pure returns(string memory){
        return "Its a Internal Function.";
    }
    function func4() private pure returns(string memory){
        return "Its a Private Function.";
    }

    function fun4() public pure returns(string memory a, string memory b){
        a = func4();
        b = func3();
    }
}

contract FuncVisibilityTest1 is FunctionVisibility{
    FunctionVisibility functionVisibilityContract;

    constructor(address _add){
        functionVisibilityContract = FunctionVisibility(_add);
    }

    function test1() public pure returns(string memory){
        return func3();
    }

    function test2() public view returns(string memory){
        return functionVisibilityContract.func1();
    }
}


contract ViewPure {
    uint public number = 10;

    function readNum() external view returns(uint num){
        num = number;
    }
    function nonRead() external pure returns(uint num){
        num = 10;
    }
}

contract StorageVar{
    struct User{
        string name;
        uint age; 
    }
    mapping(address => User) public users;

    event Log(string);

    function signup(string calldata _name, uint _age) external{
        users[msg.sender] = User(_name, _age);
    }
    function changeUser(string calldata _name) external{
        User storage user1 = users[msg.sender];
        user1.name = _name;
    }
}

