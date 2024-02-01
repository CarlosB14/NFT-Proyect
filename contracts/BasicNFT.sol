// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicNFT is ERC721, Ownable {
    string private constant TOKEN_URI1 = "token_uri1";
    string private constant TOKEN_URI1_MUTADO = "token_uri1_mutado";
    string private constant TOKEN_URI1_LETARGO = "token_uri1_letargo";
    string private constant TOKEN_URI1_MUTADO_LETARGO = "token_uri1_mutado_letargo";

    uint256 public constant mintPrice = 1 ether;
    uint256 public levelUpPrice = 1 ether;
    uint256 private _tokenCounter;
    struct NFT {
        uint256 id;
        uint256 timestampUsed;
        uint256 level;
    }

    mapping(uint256 => NFT) public nfts;

    constructor() ERC721("BasicNFT", "BNFT") Ownable(msg.sender) {
        _tokenCounter = 0;
    }

    function mint() public payable {
        require(msg.value >= mintPrice, "Not enough Ether sent");

        _createNFT();
        payable(msg.sender).transfer(msg.value - mintPrice);
        _tokenCounter++;
    }

    function mintMultiple(address[] calldata recipients) public onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            _createNFT();
            _tokenCounter++;
        }
    }

    function balance() public view returns (uint256) {
        return _tokenCounter;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
    
    function levelUp(uint256 tokenId) public payable {
        require(msg.value >= levelUpPrice, "Not enough ether sent");
        
        require(nfts[tokenId].level < 2, "Max level reached");
        nfts[tokenId].level++;
        _setCooldown(tokenId);
        payable(msg.sender).transfer(msg.value - mintPrice);
    }

    function showNFT(uint256 tokenId) public view returns (NFT memory) {
        return nfts[tokenId];
    }

    function _setCooldown(uint256 tokenId) internal {
        nfts[tokenId].timestampUsed = block.timestamp;
    }

    function _createNFT() private {
        uint256 newTokenId = _tokenCounter;
        NFT memory newNFT = NFT(newTokenId, 0, 1);
        nfts[newTokenId] = newNFT;
        _safeMint(msg.sender, newTokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (nfts[tokenId].level == 1){
            if (block.timestamp < nfts[tokenId].timestampUsed + 10){
                return TOKEN_URI1_LETARGO;
            }
            return TOKEN_URI1;
        }
        if (block.timestamp < nfts[tokenId].timestampUsed + 10){
            return TOKEN_URI1_MUTADO_LETARGO;
        }
        return TOKEN_URI1_MUTADO;
    }
}