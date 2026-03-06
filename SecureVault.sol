// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title SecureTimelockVault
 * @author Ines Krueger
 * @dev Professional vault implementation with a 24-hour withdrawal delay.
 * Demonstrates security patterns like ReentrancyGuard and Circuit Breakers.
 */
contract SecureTimelockVault is Ownable, ReentrancyGuard {
    
    mapping(address => uint256) public balances;
    mapping(address => uint256) public releaseTime;
    
    // Safety delay of 24 hours to prevent immediate theft
    uint256 public constant LOCK_TIME = 24 hours; 
    bool public emergencyPaused = false;

    event Deposited(address indexed user, uint256 amount, uint256 releaseTime);
    event Withdrawn(address indexed user, uint256 amount);
    event EmergencyStatusChanged(bool paused);

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Deposit funds into the vault. Funds will be locked for 24h.
     */
    function deposit() external payable {
        require(!emergencyPaused, "Vault is currently paused by admin");
        require(msg.value > 0, "Deposit must be greater than zero");

        balances[msg.sender] += msg.value;
        releaseTime[msg.sender] = block.timestamp + LOCK_TIME;

        emit Deposited(msg.sender, msg.value, releaseTime[msg.sender]);
    }

    /**
     * @notice Withdraw funds after the 24h timelock has expired.
     */
    function withdraw() external nonReentrant {
        require(!emergencyPaused, "Vault is currently paused");
        require(balances[msg.sender] > 0, "No balance found");
        require(block.timestamp >= releaseTime[msg.sender], "Funds are still locked (24h safety delay)");

        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @notice Emergency stop for the contract. Only callable by the owner.
     */
    function toggleEmergencyPause() external onlyOwner {
        emergencyPaused = !emergencyPaused;
        emit EmergencyStatusChanged(emergencyPaused);
    }

    function getVaultBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
