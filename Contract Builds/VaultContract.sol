// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./IERC20.sol";

contract Vault{
    IERC20 public immutable token;

    uint public totalShares;
    mapping(address => uint) public shares;

    constructor(address _token){
        token = IERC20(_token);
    }

    function _mintShare(address _add, uint _share) internal{
        shares[_add] += _share;
        totalShares += _share;
    }

    function _burnShare(address _add, uint _share) internal{
        shares[_add] -= _share;
        totalShares -= _share;
    }

    function deposite(uint _amountIn) external {
        token.transferFrom(msg.sender, address(this), _amountIn);
        
        uint shareOut;
        if(totalShares > 0){
            shareOut = (_amountIn * totalShares) / token.balanceOf(address(this));
        }
        else{
            shareOut = _amountIn;
        }

        _mintShare(msg.sender, shareOut);
    }

    function withdraw(uint _share) external returns(uint amountOut){
        amountOut = (_share * token.balanceOf(address(this)) / totalShares);
        _burnShare(msg.sender, _share);
        token.transfer(msg.sender, amountOut);
    }
}