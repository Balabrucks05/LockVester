// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";  // Corrected the typo here

contract Vesting {
    uint256 public vestingInterval; // The time between each vesting (in seconds)
    uint256 public vestingTotalIntervals; // Total number of vesting intervals
    uint256 public totalVestingAmount; // Total amount of tokens to vest
    uint256 public userVestingAmount; // Amount each user will receive per interval
    address public tokenAddress; // Address of the ERC20 token to transfer

    mapping(address => uint256) public userVestingStartTime; // To track when a user starts vesting
    mapping(address => uint256) public userClaimedAmount; // To track how much the user has already claimed

    // Constructor to set up the vesting contract when deployed
    constructor(
        uint256 _vestingInterval,
        uint256 _vestingTotalIntervals,
        uint256 _totalVestingAmount,
        address _tokenAddress
    ) {
        vestingInterval = _vestingInterval; // Set the vesting interval time
        vestingTotalIntervals = _vestingTotalIntervals; // Set the total number of intervals
        totalVestingAmount = _totalVestingAmount; // Set the total vesting amount
        tokenAddress = _tokenAddress; // Set the ERC20 token address
    }

    // Function to calculate the amount to vest per interval
    function getUserVestingAmount() public view returns (uint256) {
        return totalVestingAmount / vestingTotalIntervals;
    }

    // Function to register a user for vesting
    function register() external {
        require(userVestingStartTime[msg.sender] == 0, "You are already registered!");

        // Set the vesting start time as the block.timestamp + lock-in period (10 minutes = 600 seconds)
        userVestingStartTime[msg.sender] = block.timestamp + 180;
    }

    // Function to claim tokens after the vesting interval
    function claimTokens() external {
    uint256 startTime = userVestingStartTime[msg.sender]; // Get the vesting start time for the user
    require(startTime > 0, "You need to register first!"); // Ensure the user has registered
    require(block.timestamp >= startTime, "Vesting hasn't started yet!"); // Ensure the vesting has started

    // Calculate how many intervals have passed
    uint256 passedIntervals = (block.timestamp - startTime) / vestingInterval;
    // require(passedIntervals < vestingTotalIntervals, "Vesting period has not ended yet");

    // Calculate how much the user can claim now
    uint256 claimableAmount = passedIntervals * getUserVestingAmount();
    uint256 claimNow = claimableAmount - userClaimedAmount[msg.sender]; // Amount left to claim

    require(claimNow > 0, "No tokens to claim");

    // Update the claimed amount
    userClaimedAmount[msg.sender] += claimNow * 10 ** 18;

    // Transfer the claimable tokens to the user
    IERC20(tokenAddress).transfer(msg.sender, claimNow * 10 ** 18); // Transfer the claimable tokens
    }
}
