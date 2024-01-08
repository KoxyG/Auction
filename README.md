## English Auction NFT Smart Contract

# Description

This project implements an English auction smart contract where participants can bid for an NFT. The auction ends after a specified time, and the NFT is transferred to the highest bidder.

# Features

- English auction functionality
- ERC721 integration
- Automatic NFT transfer to the highest bidder


# FUNCTIONS USAGE

# Usage

1. **Deploying the NFT Contract**
   - Before starting the auction, deploy an ERC721-compatible NFT contract (e.g., Sepolia NFT-Contract) using your preferred deployment method.
  
  ```solidity
// SPDX-License-Identifier: MIT

// This is a random nft contract that can be used for any contract interactions

pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


contract NftContract is ERC721, Ownable {

    constructor() ERC721("KOXYNFT", "nft") Ownable(msg.sender){}

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }
}

```
2. **Minting an NFT**
   - In the deployed NFT contract, call the `_safeMint` function to mint an NFT with a specified token ID to any address of your choice. You can choose any number for the token ID.
```solidity

 // Assume you have the NFT contract instance
   nftContract.safeMint(yourAddress, tokenId);

  // this is the function being called
  function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

  

```

3. **Deploying the Auction Smart Contract**

After minting the NFT, deploy the English Auction smart contract. Pass the following parameters:
NFT contract address
Token ID
Starting bid amount
Example (using Sepolia NFT-Contract and Auction contract):

```solidity
constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        // marked payable to be able to receive ether
        seller = payable(msg.sender);
        highestBid = _startingBid;     
    }
```


4. **Approving the Auction Contract**
   - Call the approve function in the NFT contract, approving the Auction contract to use the NFT

```solidity
  // Assume you have the NFT contract instance
nftContract.approve(auctionContractAddress, tokenId);

```



**Participating in the Auction**

- Users can bid for the NFT by sending transactions to the smart contract.

# Ending the Auction
- The auction automatically ends after the specified time.
- The NFT is transferred to the highest bidder.


# Deployed Contracts

- **NFT-Contract:** [Sepolia](https://sepolia.etherscan.io/address/0x7e78e3ec7c372f0d84c6d6561e3d9e7b0c78f644)
- **Auction contract:** [Sepolia](https://sepolia.etherscan.io/address/0x55d0adec17c1d71921078687e37908d57c9972a9)

