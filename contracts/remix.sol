// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNft is ERC721, Ownable {
    uint256 private tokenCounter;
    uint256 private price = 1 ether;
    string private constant TOKEN_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    constructor() ERC721("Desk", "DSK") Ownable(msg.sender){
        tokenCounter = 0;
    }

    function mintNft() public payable {
        require(msg.value >= price, "Insuficient money");
        _safeMint(msg.sender, tokenCounter);

        uint256 remainder = msg.value - price;
        payable(msg.sender).transfer(remainder);

        tokenCounter = tokenCounter + 1;
    }

    function mintMultiple(address[] calldata recipients) public payable onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            _safeMint(recipients[i], tokenCounter);
            tokenCounter = tokenCounter + 1;
        }
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return TOKEN_URI;
    }

    function getTokenCounter() public view returns (uint256) {
        return tokenCounter;
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
