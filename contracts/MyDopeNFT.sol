// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyDopeNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 totalMinted;

  string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
  string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  string[] firstWords = ["Naruto", "Kakashi", "Itachi", "Mitsuki", "Sasuke", "Minato", "Hashirama", "Sakura", "Jiraiya", "Hinata", "Shisui", "Tsunade", "Ino", "Boruto", "Madara", "Kawaki"];
  string[] secondWords = ["Bitcoin", "Ethereum", "Cardano", "Solana", "Polkadot", "Dogecoin", "Terra", "Uniswap", "Litecoin", "Chainlink", "Algorand", "Polygon", "Stellar", "VeChain", "Fantom", "Hedera"];
  string[] thirdWords = ["Sushi", "Ramen", "Katsu", "Curry", "Tsukemen", "Udon", "Nigiri", "Onigiri", "Sashimi", "Tempura", "Yakitori", "Gyoza", "Donburi", "Takoyaki", "Wagyu"];

  string[] colors = ["#fcba21", "#f05321", "#024da1", "#f072ac", "#9b00b8", "#db0138", "#000000", "#2782ff"];

  event NewNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("DopeNFT", "DOPE") {
    console.log("First NFT contract!");
  }

  function pickRandomFirst(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecond(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThird(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function pickRandomColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
    rand = rand % colors.length;
    return colors[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked((input))));
  }

  function makeNFT() public {
    require(
      totalMinted < 50,
      "Max amount of NFTs has been reached"
    );

    uint256 newItemId = _tokenIds.current();

    string memory first = pickRandomFirst(newItemId);
    string memory second = pickRandomSecond(newItemId);
    string memory third = pickRandomThird(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    string memory randomColor = pickRandomColor(newItemId);
    string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            combinedWord,
            '", "description": "The Naruto x Crypto collab you never knew you needed.", "image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(finalSvg)),
            '"}'
          )
        )
      )
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    _tokenIds.increment();

    totalMinted = newItemId + 1;
    
    emit NewNFTMinted(msg.sender, newItemId);
  }

  function getTotalMinted() public view returns (uint256) {
    console.log(totalMinted);
    return totalMinted;
  }
}