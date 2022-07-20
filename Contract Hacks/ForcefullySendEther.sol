// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Vault{
    function contractBalance() external view returns(uint){
        return address(this).balance;
    }
}

contract ForceSendEth{
    receive() external payable{}
   
    constructor() payable{}  // to make contract receiver ether during contract deployment.
    function contractBalance() external view returns(uint){
        return address(this).balance;
    }
    
    function destroy(address _vault) external{
        selfdestruct(payable(_vault));
    }
}
