// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./IERC20.sol";

contract CSAMM{
    IERC20 public immutable token1;
    IERC20 public immutable token2;

    uint public reserve1;
    uint public reserve2;

    uint public totalSupply;
    mapping(address => uint) public shares;

    constructor(address _token1, address _token2){
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }

    function _updateReserve(uint _res1, uint _res2) internal {
        reserve1 = _res1;
        reserve2 = _res2;
    } 

    function _mintShare(address _add, uint _share) internal{
        shares[_add] += _share;
        totalSupply += _share;
    }

    function _burnShare(address _add, uint _share) internal{
        shares[_add] -= _share;
        totalSupply -= _share;
    }

    // SWAP
    function swap(address _tokenIn, uint _amountIn) public returns(uint amountOut){
        require(token1 == IERC20(_tokenIn) || token2 == IERC20(_tokenIn), "Invalid Address.");

        bool isToken1 = _tokenIn == address(token1);

        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken1 
        ? (token1, token2, reserve1, reserve2) 
        : (token2, token1, reserve2, reserve1);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenIn.balanceOf(address(this)) - reserveIn;

        amountOut = (amountIn * 997) / 1000;

        (uint res1, uint res2) = isToken1 ? (reserveIn + amountIn, reserveOut - amountOut) : (reserveOut - amountOut, reserveIn + amountIn);
        _updateReserve(res1, res2);

        tokenOut.transfer(msg.sender, amountOut);
    }

    // ADD LIQUIDITY
    function addLiquidity(uint _amount1, uint _amount2) public returns(uint share){
        token1.transferFrom(msg.sender, address(this), _amount1);
        token2.transferFrom(msg.sender, address(this), _amount2);

        uint res1 = token1.balanceOf(address(this));
        uint res2 = token2.balanceOf(address(this));

        uint a1 = res1 - reserve1;
        uint a2 = res2 - reserve2;

        /*
        a = amount in
        L = total liquidity
        s = shares to mint
        T = total supply

        s should be proportional to increase from L to L + a
        (L + a) / L = (T + s) / T

        s = a * T / L
        */
        if(totalSupply > 0){
            share = ((a1 + a2) * totalSupply) / (reserve1 + reserve2);
        }
        else{
            share = a1 + a2;
        }

        if(share > 0){
            _mintShare(msg.sender, share);
        }
        _updateReserve(res1, res2);
    }

    // REMOVE LIQUIDITY
    function removeLiquidity(uint _share) public{
        uint calcA1 = (_share * reserve1) / totalSupply;
        uint calcA2 = (_share * reserve2) / totalSupply;

        _burnShare(msg.sender, _share);
        _updateReserve(reserve1-calcA1, reserve2-calcA2);

        if(calcA1 > 0){
            token1.transfer(msg.sender, calcA1);
        }
        if(calcA2 > 0){
            token2.transfer(msg.sender, calcA2);
        }
    }
}