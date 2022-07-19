// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

/* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer

*/

contract VerifySign{
    function _splitSignature(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v){
        require(_sig.length == 65, "Invalid Signature Length");

        // _sig is a pointer to the location where signature stored
        // Signature is dynamic data cause it has variable length. 
        // first 32bytes = signifies length of Sig

        assembly{
            r := mload(add(_sig, 32)) // skipping first 32 then storing next 32
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }

    function verify(address _signer, string memory _msg, bytes memory _sig) external pure returns(bool){
        bytes32 hashMsg = hashingMsg(_msg);
        bytes32 ethHashMsg = ethHashingMsg(hashMsg);

        return recover(ethHashMsg, _sig) == _signer;
    }

    function hashingMsg(string memory _msg) public pure returns(bytes32){
        return keccak256(abi.encode(_msg));
    }

    function ethHashingMsg(bytes32 _hashmsg) public pure returns(bytes32){
        return keccak256(abi.encodePacked(
            "\x19Ethereum I'm Satyabrata Dash: \n32",
            _hashmsg
        ));
    }

    function recover(bytes32 _ethHashingMsg, bytes memory _sig) public pure returns(address){
        (bytes32 r, bytes32 s, uint8 v) = _splitSignature(_sig);
        return ecrecover(_ethHashingMsg, v, s, r);
    }
}