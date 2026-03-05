# TipJar Smart Contract
A decentralized TipJar system allowing users to create personal jars and receive tips in multiple verified ERC20 tokens. This contract is designed to act as a record-keeper for successful on-chain transfers.

Features
Multi-Token Support: Manage a whitelist of allowed tip tokens.

Personalized Jars: Users can create a jar with a custom name and track their balance.

Tip History: Stores sender address, timestamp, and a custom message for every tip.

Active Status: Owners can toggle their jar's visibility/status to pause incoming tips.

Gas Optimized: Uses calldata and storage pointers to minimize execution costs.

Core Functions
For Users & Tippers
createTipJar(address owner, string ownerName, uint date) Initializes a new jar. Only one jar is allowed per address.

addTipForOwner(address owner, Token token, address sender, string message, uint date) Records a tip in the system. Typically called by a payment processor or as a callback after a successful transfer.

getTipsForOwner(address owner) Returns the full TipJar struct, including balance, metadata, and all tip history.

For Administrators
allowTokenForTips(address tokenAddress) Adds a specific ERC20 token to the system's whitelist.

removeTokenForTips(address tokenAddress) Removes a token from the whitelist to prevent further tips in that currency.

Data Structures
TipJar Struct
Solidity

struct TipJar {
    uint balance;
    address owner;
    string ownerName;
    uint date;
    bool isActive;
    Tip[] tips;
}
Tip Struct
Solidity

struct Tip {
    address sender;
    string message;
    Token token;
    uint date;
}
Security & Validations
onlyActive Modifier: Prevents tips from being recorded if a jar is deactivated or doesn't exist.

checkIfAllowedToken: Ensures only system-approved tokens are processed.

Zero-Value Protection: Reverts any tip with an amount of 0.

Setup & Deployment
Compile using Solidity ^0.8.0.

Deploy the contract.

Use allowTokenForTips to whitelist your desired ERC20 tokens (e.g., USDC, DAI).

Integrate with your frontend using Ethers.js or Web3.js.