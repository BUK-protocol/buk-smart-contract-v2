# Travel and Hospitality Smart Contracts of Buk Protocol

This repository contains the smart contracts for Buk Protocol for Travel and Hospitality.[To know More](https://docs.bukprotocol.io/buk-protocol-v2/industries/travel-and-hospitality-applications-of-buk-protocol)

BUK Protocol allows creation of Blockchain based NFT bookings and tickets ensuring provenance of inventory and enabling creation of open and efficient secondary markets for travel bookings. Thus:

- Tokenizing hotel room or airline ticket bookings to bring them on-chain. [Like this](https://www.youtube.com/watch?v=5aVNuSoIwzM)
- Enabling creation of ticketing marketplaces for primary and secondary sale [Like this](https://www.youtube.com/watch?v=yxrm-qMTcHY)
- Creating a wider distribution for ticket sales across multiple marketplaces (Rarible, OpenSea, etc.) with a single integration [Like this](https://rarible.com/veecon-2023-tickets/items)

### Buk Protocol sub contracts

- `Buk Protocol Contract` - The BukProtocol contract is a Solidity smart contract designed for a booking system that leverages the power of Non-Fungible Tokens (NFTs). It provides functionalities for users to book rooms, manage their bookings, and interact with related NFTs.
- `Buk NFTs Contract` - The BukNFTs contract is a Solidity smart contract designed for managing hotel room-night inventory and ERC1155 token management for room-night NFTs.
- `Buk Treasury Contract` - The Treasury contract is a Solidity smart contract designed for managing the fund management for Buk protocol and and other marketplace contracts. This contract controls all kind of transactions money.
- `Buk Marketplace Contract` - The Marketplace contract is a Solidity smart contract designed for managing the listing, delisting, buying, and other marketplace functionalities for BUK Protocol NFTs.
- `Buk POS NFT Contract` - The BukPOSNFTs contract is a Solidity smart contract designed for managing Proof-of-Stay utility NFT ERC1155 token.
- `Buk Signature Verifier Contract` - The SignatureVerifier contract is a Solidity smart contract designed to verify the signature of hashed messages using the ECDSA cryptographic algorithm. It provides a utility to ensure the authenticity of messages within the Buk Protocol.
- `Buk ROyalty Contract` - The BukRoyalties contract is a Solidity smart contract designed to manage the royalty system for the Buk Protocol. It provides functionalities to set and retrieve royalty information for various entities involved in the protocol.

## Audit Details 🔍

The BUK smart contract has undergone a comprehensive security audit by QuillAudits, a leading blockchain security firm. The audit involved a thorough review of the contract's security, documentation alignment, gas optimization, and code quality. QuillAudits identified and addressed several vulnerabilities, enhancing the platform's security and reliability. You can find the detailed audit report on the QuillAudits [website](https://www.quillaudits.com/leaderboard/buk-protocol)

## Getting Started

To get started with the BUK smart contract using Hardhat, follow these steps:

1.  **Clone the repository**:
    `git clone https://github.com/BUK-protocol/buk-smart-contract-v2.git`

2.  **Install dependencies**:
    `cd buk-smart-contract-v2`
    `npm install`

3.  **Compile the contract**:
    `npx hardhat compile`

4.  **Deploy the contract**:
    `npx hardhat run scripts/deploy.js`

5.  **Test the contract**:
    `npx hardhat test`

\***\*Contributing 🤝\*\***
We welcome contributions from the community! If you would like to contribute to the BUK smart contract, please follow these guidelines:

1.  **Fork the repository**
2.  **Create a new branch for your feature or bug fix**
3.  **Write tests for your changes**
4.  **Submit a pull request**

\***\*License 📜\*\***
The Buk Protocol smart contract is licensed under the MIT License.

![solidity](https://img.shields.io/badge/Solidity-e6e6e6?style=for-the-badge&logo=solidity&logoColor=black) ![openzeppelin](https://img.shields.io/badge/OpenZeppelin-4E5EE4?logo=OpenZeppelin&logoColor=fff&style=for-the-badge)
