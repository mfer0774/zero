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

    string[22] private firstNames = ["","","","","","","","","","","","","","","","","","","","","",""];
    string[22] private lastNames = ["","","","","","","","","","","","","","","","","","","","","",""];
    string[5] private colors = ["","","","",""];

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getRandomColor() {

    }

    function getSVG() internal view returns (string memory) {
        string svgOne = "<svg viewBox='0 0 90 90' fill='none' role='img' xmlns='http://www.w3.org/2000/svg' width='350' height='350'>";
        string svgTwo = "<mask id='mask' maskUnits='userSpaceOnUse' x='0' y='0' width='90' height='90'><rect width='90' height='90' rx='180' fill='#FFFFFF'></rect></mask><g mask='url(#mask)'>";
        string svgThree = string("<path d='M0 0h90v45H0z' fill='", getRandomColor(), "'></path>");
        string svgFour = string("<path d='M0 45h90v45H0z' fill='", getRandomColor(), "'></path>");
        string svgFive = string("<path d='M83 45a38 38 0 00-76 0h76z' fill='", getRandomColor(), "'></path>");
        string svgSix = string("<path d='M83 45a38 38 0 01-76 0h76z' fill='", getRandomColor(), "'></path>");
        string svgSeven = string("<path d='M77 45a32 32 0 10-64 0h64z' fill='", getRandomColor(), "'></path>");
        string svgEight = string("<path d='M77 45a32 32 0 11-64 0h64z' fill='", getRandomColor(), "'></path>");
        string svgNine = string("<path d='M71 45a26 26 0 00-52 0h52z' fill='", getRandomColor(), "'></path>");
        string svgTen = string("<path d='M71 45a26 26 0 01-52 0h52z' fill='", getRandomColor(), "'></path>");
        string svgEleven = string("<circle cx='45' cy='45' r='23' fill='", getRandomColor(), "'></circle></g></svg>");
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
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, "data:application/json;base64,ewogICJuYW1lIjogInplcm8iLAogICJkZXNjcmlwdGlvbiI6ICJ0aGUgZmlyc3Qgb25lIiwKICJpbWFnZSI6ImRhdGE6aW1hZ2Uvc3ZnK3htbDtiYXNlNjQsUEhOMlp5QjJhV1YzUW05NFBTSXdJREFnT0RBZ09EQWlJR1pwYkd3OUltNXZibVVpSUhKdmJHVTlJbWx0WnlJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWlCM2FXUjBhRDBpT0RBaUlHaGxhV2RvZEQwaU9EQWlQZ29nSUNBZ1BIUnBkR3hsUGsxaGNua2dRbUZyWlhJOEwzUnBkR3hsUGdvZ0lDQWdQRzFoYzJzZ2FXUTlJbTFoYzJ0ZlgySmhkV2hoZFhNaUlHMWhjMnRWYm1sMGN6MGlkWE5sY2xOd1lXTmxUMjVWYzJVaUlIZzlJakFpSUhrOUlqQWlJSGRwWkhSb1BTSTRNQ0lnYUdWcFoyaDBQU0k0TUNJK0NpQWdJQ0FnSUNBZ1BISmxZM1FnZDJsa2RHZzlJamd3SWlCb1pXbG5hSFE5SWpnd0lpQm1hV3hzUFNJalJrWkdSa1pHSWo0OEwzSmxZM1ErQ2lBZ0lDQThMMjFoYzJzK0NpQWdJQ0E4WnlCdFlYTnJQU0oxY213b0kyMWhjMnRmWDJKaGRXaGhkWE1wSWo0S0lDQWdJQ0FnSUNBOGNtVmpkQ0IzYVdSMGFEMGlPREFpSUdobGFXZG9kRDBpT0RBaUlHWnBiR3c5SWlNMFlqVXpPR0lpUGp3dmNtVmpkRDRLSUNBZ0lDQWdJQ0E4Y21WamRDQjRQU0l4TUNJZ2VUMGlNekFpSUhkcFpIUm9QU0k0TUNJZ2FHVnBaMmgwUFNJNE1DSWdabWxzYkQwaUl6RTFNVGt4WkNJZ2RISmhibk5tYjNKdFBTSjBjbUZ1YzJ4aGRHVW9MVGdnTFRncElISnZkR0YwWlNnek1qQWdOREFnTkRBcElqNDhMM0psWTNRK0NpQWdJQ0FnSUNBZ1BHTnBjbU5zWlNCamVEMGlOREFpSUdONVBTSTBNQ0lnWm1sc2JEMGlJMlkzWVRJeFlpSWdjajBpTVRZaUlIUnlZVzV6Wm05eWJUMGlkSEpoYm5Oc1lYUmxLQzB6SUMwektTSStQQzlqYVhKamJHVStDaUFnSUNBZ0lDQWdQR05wY21Oc1pTQmplRDBpTkRBaUlHTjVQU0kwTUNJZ1ptbHNiRDBpSTJVME5UWXpOU0lnY2owaU1USWlJSFJ5WVc1elptOXliVDBpZEhKaGJuTnNZWFJsS0RRMUlEY3lLU0krUEM5amFYSmpiR1UrQ2lBZ0lDQWdJQ0FnUEd4cGJtVWdlREU5SWpBaUlIa3hQU0kwTUNJZ2VESTlJamd3SWlCNU1qMGlOREFpSUhOMGNtOXJaUzEzYVdSMGFEMGlNaUlnYzNSeWIydGxQU0lqWlRRMU5qTTFJaUIwY21GdWMyWnZjbTA5SW5SeVlXNXpiR0YwWlNnd0lEQXBJSEp2ZEdGMFpTZ3lPREFnTkRBZ05EQXBJajQ4TDJ4cGJtVStDaUFnSUNBOEwyYytDand2YzNablBnPT0iCn0=");
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
