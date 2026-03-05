// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract TipContract {
    struct Token {
        string ticker;
        uint amount;
        address tokenAddress;
    }

    struct Tip {
        address sender;
        string message;
        Token token;
        uint date;
    }

    struct TipJar {
        uint balance;
        address owner;
        string ownerName;
        uint date;
        Tip[] tips;
        bool isActive;
    }

    mapping(address addr => Tip) public senders;
    mapping(address owner => TipJar) public tipJars;

    //allowable tokens in the system
    mapping (address => bool) public tokens;

    event TipJarCreation(address owner, string ownername, uint date);
    event AddedTokenToTokenList(address tokenAddr);
    event TipOwner(address owner, address sender, Tip tip);
    event JarActivated(address owner);
    event JarDeActivated(address owner);


    modifier checkIfAllowedToken(address _tokenAddr){
        require(tokens[_tokenAddr], "Tipped token is not allowed");
        _;
    }

    modifier checkIfJarIsActive(address owner) {
        require(tipJars[owner].owner!= address(0), "No tipjars exist for this owner");
        require(tipJars[owner].isActive, "This tipJar cannot currenyl receive tips");
        _;
    }
    
    function allowTokenForTips(address tokenAddress) public{
        require(!tokens[tokenAddress], "This token is already allowed by the system");
        tokens[tokenAddress] = true;

        emit AddedTokenToTokenList(tokenAddress);
    }

    function removeTokenForTips(address tokenAddress) public {
        require(tokens[tokenAddress], "This token has already been removed from the system");

        tokens[tokenAddress] = false;
    }

    function createTipJar(address owner, string calldata ownerName, uint date) public {
        require(tipJars[owner].owner == address(0), "There is an existing jar for this user");

        TipJar storage newjar = tipJars[owner];
        newjar.balance = 0;
        newjar.owner = owner;
        newjar.ownerName = ownerName;
        newjar.date = date;
        
        emit TipJarCreation(owner, ownerName, date);
    }


    function addTipForOwner(address owner, Token calldata token, address sender, string calldata message, uint date)
     public 
     checkIfAllowedToken(token.tokenAddress) 
     checkIfJarIsActive(owner)
     {
        require(token.amount > 0, "Cannot tip 0 tokens");
        
        TipJar storage tipJar = tipJars[owner];

        require(tipJar.owner!= address(0), "No tipjars exist for this owner");

        tipJar.tips.push(Tip({sender:sender, message:message, token: token, date:date}));
        
        tipJar.balance += token.amount;

        emit TipOwner(owner, sender,Tip({sender:sender, message:message, token: token, date:date}));
    }

    function getTipsForOwner(address owner) public view returns (TipJar memory) {
        require(tipJars[owner].owner!= address(0), "No tipjars exist for this owner");
        return tipJars[owner];
    }

    function activateTipJar(address owner) public{
        TipJar memory tipJar = tipJars[owner];
        require(!tipJar.isActive, "This tipjar is already active");
        tipJar.isActive = true;
        emit JarDeActivated(owner);
    }

    function deactivateTipJar(address owner) public checkIfJarIsActive(owner){
      tipJars[owner].isActive = false;
      emit JarDeActivated(owner);
    }
}
