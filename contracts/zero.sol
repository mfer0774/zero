// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import { Base64 } from "./libraries/Base64.sol";
import "hardhat/console.sol";

contract Zero is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint public maxSupply = 42;
    uint public maxMint = 2;
    uint public numTokensMinted;

    string[5] private colors = ["#F0D8A8","#3D1C00","#86B8B1","#F2D694","#FA2A00"];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getRandomColor(string memory input) internal view returns (string memory) {
        uint256 rand = random(input);
        rand = rand % colors.length;
        return colors[rand];
    }

    function getSVG(string memory itemId) internal view returns (string memory) {
        string memory svgOne = "<svg viewBox='0 0 90 90' fill='none' role='img' xmlns='http://www.w3.org/2000/svg' width='350' height='350'>";
        string memory svgTwo = "<mask id='mask' maskUnits='userSpaceOnUse' x='0' y='0' width='90' height='90'><rect width='90' height='90' rx='180' fill='#FFFFFF'></rect></mask><g mask='url(#mask)'>";
        string memory svgThree = string(abi.encodePacked("<path d='M0 0h90v45H0z' fill='", getRandomColor(string(abi.encodePacked("three",itemId))), "'></path>"));
        string memory svgFour = string(abi.encodePacked("<path d='M0 45h90v45H0z' fill='", getRandomColor(string(abi.encodePacked("four", itemId))), "'></path>"));
        string memory svgFive = string(abi.encodePacked("<path d='M83 45a38 38 0 00-76 0h76z' fill='", getRandomColor(string(abi.encodePacked("five", itemId))), "'></path>"));
        string memory svgSix = string(abi.encodePacked("<path d='M83 45a38 38 0 01-76 0h76z' fill='", getRandomColor(string(abi.encodePacked("six", itemId))), "'></path>"));
        string memory svgSeven = string(abi.encodePacked("<path d='M77 45a32 32 0 10-64 0h64z' fill='", getRandomColor(string(abi.encodePacked("seven", itemId))), "'></path>"));
        string memory svgEight = string(abi.encodePacked("<path d='M77 45a32 32 0 11-64 0h64z' fill='", getRandomColor(string(abi.encodePacked("eight", itemId))), "'></path>"));
        string memory svgNine = string(abi.encodePacked("<path d='M71 45a26 26 0 00-52 0h52z' fill='", getRandomColor(string(abi.encodePacked("nine", itemId))), "'></path>"));
        string memory svgTen = string(abi.encodePacked("<path d='M71 45a26 26 0 01-52 0h52z' fill='", getRandomColor(string(abi.encodePacked("ten", itemId))), "'></path>"));
        string memory svgEleven = string(abi.encodePacked("<circle cx='45' cy='45' r='23' fill='", getRandomColor(string(abi.encodePacked("eleven", itemId))), "'></circle></g></svg>"));
        string memory finalSvg = string(abi.encodePacked(svgOne, svgTwo, svgThree, svgFour, svgFive, svgSix, svgSeven, svgEight, svgNine, svgTen, svgEleven));

        return finalSvg;
    }

    constructor() ERC721("Zero", "ZRO") {}

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function mint() public {
        uint256 newItemId = _tokenIdCounter.current();
        string memory itemId = string(abi.encodePacked(newItemId));
        string memory name = string(abi.encodePacked("Zero: ", Strings.toString(newItemId)));
        string memory svg = getSVG(itemId);

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "', name,'", "description": "weeeee", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)),'"}'))));
        
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIdCounter.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    }

    function withdrawAll() public payable onlyOwner {
        require(payable(_msgSender()).send(address(this).balance));
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
