// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TipContract{
    
    struct Token{
    string name;
    string ticker;
    string amount;
  }
  
  struct Tip{
    address sender;
    uint amount;
    string message;
    Token token;
  }

  struct TipJar{
    uint balance;
    address payable owner;
    string ownerName;
    uint date;
  }

   mapping(address addr=>  Tip ) public senders,
  
}
