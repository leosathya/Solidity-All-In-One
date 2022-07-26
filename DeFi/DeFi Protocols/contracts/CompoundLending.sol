// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/compound/compound.sol";

contract LendingUsingCompound{
    IERC20 public token;
    CErc20 public cToken;

    constructor(address _token, address _cToken){
        token = IERC20(_token);
        cToken = CErc20(_cToken);
    }

    function supplyToken(uint _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        token.approve(address(cToken), _amount);

        // Lending to compound
        // if output not 0, then lending failed
        require(cToken.mint(_amount) == 0, "Lending Failed.");
    }

    function getCTokenBal() external view returns(uint){
        return cToken.balanceOf(msg.sender);
    }

    // Not View function, so have to send transaction (Make staticCall)
    function getInfo() external returns(uint exchangeRate, uint supplyRate){
        // exchangeRate = exchangeRate to cToken to Token that supplied
        // supplyRate = Interest for supplying token
        exchangeRate = cToken.exchangeRateCurrent();
        supplyRate = cToken.supplyRatePerBlock();
    }

    function estimatingUnderlyingTokenBalance() external returns(uint){
        uint cTokenBal = cToken.balanceOf(address(this));
        uint exchangeRate = cToken.exchangeRateCurrent();
        uint decimals = 8; // WBTC = 8 decimals
        uint cTokenDecimals = 8;

        return (cTokenBal * exchangeRate) / 10 ** (18 + decimals - cTokenDecimals);
    }

    function balanceOfUnderlying() external returns(uint){
        return cToken.balanceOfUnderlying(address(this));
    }

    function redeemToken(uint _cTokenAmount) external {
        require(cToken.redeem(_cTokenAmount) == 0, "Reedme Token Failed.");
    }
}