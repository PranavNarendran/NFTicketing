// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721.sol";
import "./ERC721Burnable.sol";
import "./Ownable.sol";

contract MyToken is ERC721, ERC721Burnable, Ownable {
    constructor() ERC721("MyToken", "MTK") {}
    uint tokenId=0;
    uint maxTokens=12; //provided by the event host
    uint256 public mintRate=0.08 ether; //provided by event host


    mapping(address => uint) hasMinted;
    mapping(address => uint) ticketType;
    mapping(address =>uint)  myTokenNumber;

    function imageURI() public pure returns (string memory) {
        return "bvb";  //provided by event host
    }

    function userHasMinted(address a) public view returns(uint)
    {
        return hasMinted[a]; //returns 1 if the address has minted a token ,0 otherwise

    }

    function userTicketType(address a) public view returns(uint)
    {
        return ticketType[a]; //returns the type of ticket ,ticketType[address]=1,5 =>silver,ticketType[address]=2 => gold,else normal ticket

    }

    function userMyTokenNumber(address a) public view returns(uint)
    {
        return myTokenNumber[a];//returns token number of that address

    }

    function safeMint(address to) public payable {
        require(tokenId < maxTokens ,"Token mint limit reached.");
        require(msg.value >= mintRate,"Not enough ether sent");
        require(hasMinted[to]!=1,"User has already minted a token");
        tokenId=tokenId+1;
        hasMinted[to]=1;
        ticketType[to]=(uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty, msg.sender))) % 10)+1;
        myTokenNumber[to]=tokenId;
        _safeMint(to, tokenId);
        
    }

    function withdrawEther() public onlyOwner
    {
        require(address(this).balance > 0,"Balance in this contract is 0");
        payable(owner()).transfer(address(this).balance); 
        
        //owner() function : returns the address of this smart contract deployer
        //payable(owner()) : allows the owner to send and receive ether.
        //address(this).balance returns : returns the balance locked in the current smart contract.
        //payable(owner()).transfer(address(this).balance) : sends the ether locked in this smart contract to the deployer of this smart contract
    }
}
