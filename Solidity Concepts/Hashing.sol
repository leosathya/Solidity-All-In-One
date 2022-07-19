// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Hashing{
    enum StudentStatus{EXCELLENT, VERYGOOD, GOOD}
    StudentStatus public status;

    struct Student{
        uint rollNo;
        string name;
        uint age;
        string[2] subjects;
        StudentStatus grade;
    }

    struct Name{
        string fname;
        string lname;
    }

    function hashing(uint _rollNo, string calldata _name, uint _age,  string[2] calldata _subjects) external pure returns(bytes32 ){
        StudentStatus _status = StudentStatus.EXCELLENT;
        Student memory student = Student(_rollNo, _name, _age, _subjects, _status);
        // Array, Struct are not supported in encodePacked mode
        return keccak256(abi.encodePacked(_rollNo, _name, _age, _status));
    }

    // Array, Struct are not supported in encodePacked mode
    // Example of hash collision
    // Hash collision can occur when you pass more than one dynamic data type
    // to abi.encodePacked. In such case, you should use abi.encode instead.

    function hashing2(Name calldata _name) external pure returns(bytes32 ){
        return keccak256(abi.encode(_name));
    }
}