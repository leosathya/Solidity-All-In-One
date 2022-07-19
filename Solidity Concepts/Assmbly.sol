// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/*
. Solidity assembly is a low language that allow you to directly manipulate EVM memory
. EVM = run opcodes (100 opcodes in total) using assembly these can modified
. each slot is 256bits (32 bytes)

*/

contract Assembly{

    function sum() external returns(bool){
        uint a;
        uint b;
        uint c = a+b;

        uint size;
        address addr = msg.sender;

        /// Conveting bytes to bytes32
        bytes memory data = new bytes(100);
        bytes32 requiredData;


        assembly {
            c := add(1,2)
            //mload(0x40) // return next empty slot
            mstore(a, 2) // storing in memory
            sstore(a, 10) // storing in blockchain
            /*
            extcodesize() // return code size at a perticular address
                          // if it was not a contract address then code size = 0, if > 0 = this 
                          is a smartcontract
            */

            size := extcodesize(addr)

            // simplely fetching requires data from bytes and storing in bytes32
            requiredData := mload(add(data, 32))

        }
        if(size > 0){
            return true;
        }
        else return false;
    }
    
}