// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./interfaces/uniswap/Uniswap.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IWETH.sol";

contract SwappingToken{
    address private constant UNISWAP_V2_ROUTER =0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function Swapping(address tokenIn, address tokenOut, uint amountIn, uint amountMinOut, address to) external {
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        IERC20(tokenIn).approve(address(this), amountIn);
        // IWETH(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        // IWETH(tokenIn).approve(address(this), amountIn);

        address[] memory paths = new address[](2);
        paths[0] = tokenIn;
        //paths[1] = WETH;
        paths[1] = tokenOut;

        IUniswapV2Router(UNISWAP_V2_ROUTER).swapExactTokensForTokens(amountIn, amountMinOut, paths, to, block.timestamp);
    }
}