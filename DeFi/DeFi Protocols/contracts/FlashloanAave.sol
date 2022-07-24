// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/aave/FlashLoanReceiverBase.sol";

contract TestAaveFlashloan is FlashLoanReceiverBase{
    using SafeMath for uint;

    event Log(string , uint);

    constructor(ILendingPoolAddressesProvider _addressProvider) FlashLoanReceiverBase(_addressProvider){}

    function makeFlashloan(address _asset, uint _amount) external {
        address receiverAddress = address(this);
        address[] memory assets = new address[](1);
        assets[0] = _asset;

        uint[] memory amounts = new uint[](1);
        amounts[0] = _amount;

        uint[] memory modes = new uint[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(receiverAddress, assets, amounts, modes, onBehalfOf, params, referralCode);
    }

    function executeOperation(
        address[] calldata assets,
        uint[] calldata amounts,
        uint[] calldata premimums,
        address initiator,
        bytes calldata params
    ) external override returns(bool){
        // do the arbritage
        // decode params
        // return aave fund

        for(uint i; i<amounts.length; i++){
            emit Log("borrow amount == ", amounts[i]);
            emit Log("fee amount == ", premimums[i]);

            uint netAmountToPay = amounts[i].add(premimums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), netAmountToPay);
        }
        return true;
    }
}