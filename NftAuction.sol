// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";

contract NftAuction {

    event Start();
    event Bid(address indexed sender,  uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address winner, uint amount);


    IERC721 public nft;
    uint public nftId;

    // marked payable to be able to receive ether
    address payable public seller;
    uint public endAt;
    bool public started;
    bool public ended;


    address public highestBidder;
    uint public highestBid;


    // mapping to store the list of bidders.
    mapping(address => uint) public bids;


    constructor(address _nft, uint _nftId, uint _startingBid) {
        nft = IERC721(_nft);
        nftId = _nftId;

        // marked payable to be able to receive ether
        seller = payable(msg.sender);
        highestBid = _startingBid;     
    }

    // function to start auction
    // make sure to approve the contract before calling
    function start(uint256 _endTime) external {
        require(!started, "Auction started");
        require(msg.sender == seller, "you are not the seller");

        // make sure to approve the contract before calling
        nft.transferFrom(msg.sender, address(this), nftId);
        
        started = true;
        endAt = block.timestamp + _endTime;

        emit Start();
    }

    function bid(uint256 _amount) external payable {
        require(started, "Auction not started");
        require(block.timestamp < endAt, "ended");
        require(_amount > highestBid, "amount is less than the initial bid");

        if(highestBidder != address(0)) {
            bids[highestBidder] = bids[highestBidder] + highestBid;
        }

        highestBidder = msg.sender;
        highestBid = _amount;

        emit Bid(msg.sender, _amount);
    }


    function withdraw() external {
        uint256 bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);

        emit Withdraw(msg.sender, bal);
    }


    function end() external {
        require(started, "Auction not started");
        require(block.timestamp >= endAt, "Auction is still on");
        require(!ended, "Auction has ended");

        ended = true;

        if(highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }

}
