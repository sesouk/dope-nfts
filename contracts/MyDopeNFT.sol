// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyDopeNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  constructor() ERC721 ("DopeNFT", "DOPE") {
    console.log("First NFT contract!");
  }

  function makeNFT() public {
    uint256 newItemId = _tokenIds.current();

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, "Stuff and things");

    _tokenIds.increment();
  }
}