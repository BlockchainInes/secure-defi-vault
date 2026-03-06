# 🛡️ Secure DeFi Timelock Vault
**Demonstrating Smart Contract Security & Asset Protection**

## Project Overview
This repository contains a professional Ethereum vault designed to protect assets. It implements a mandatory 24-hour withdrawal delay to prevent immediate theft if a private key is compromised.

## Key Security Features
- **24h Timelock:** Prevents instant withdrawals.
- **Reentrancy Protection:** Uses OpenZeppelin's `ReentrancyGuard`.
- **Emergency Pause:** Circuit breaker for administrators.

## Technical Proof (Security Test)
As shown in the test below, an immediate withdrawal attempt is rejected by the contract:

![Security Test Proof](./image_7e42a6.png)
*(Image showing the 24h lock error in Remix)*

## Deployment
- **Language:** Solidity 0.8.20
- **Framework:** Remix IDE / OpenZeppelin
