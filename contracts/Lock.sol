// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TipContract {
    struct Token {
        string name;
        string ticker;
        string amount;
    }

    struct Tip {
        address sender;
        uint amount;
        string message;
        Token token;
        uint data;
    }

    struct TipJar {
        uint balance;
        address payable owner;
        string ownerName;
        uint date;
        Tip[] tips;
    }

    mapping(address addr => Tip) public senders;
    mapping(address owner => TipJar) public tipJars;

    function createTipJar(address owner, string memory ownerName) public {}
}
