// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract MultiAuction {

    struct Auction {
        address payable owner;
        string itemName;
        uint auctionEndTime;
        uint highestBid;
        address highestBidder;
        mapping(address => uint) bids;
        bool ended;
    }
    address public admin;
    uint public auctionDurationMinutes;
   
    uint numRequests;
    mapping(uint =>Auction) public auctionss;

    event NewAuction(address indexed owner, string itemName, uint auctionEndTime);
    event NewBid(uint auctionIndex, address indexed bidder, uint amount);
    event AuctionEnded(uint auctionIndex, address winner, uint amount);

    constructor() {
        admin = msg.sender;
    }

    function setduration(uint _duration) public{
        auctionDurationMinutes = _duration;
    }
    function createAuction(string memory _itemName) public {

            Auction storage auc = auctionss[numRequests++];


            // Auction storage newAuction = Auction({
            auc.owner= payable(msg.sender);
            auc.itemName= _itemName;
            auc.auctionEndTime= block.timestamp + (auctionDurationMinutes * 1 minutes);
            auc.highestBid= 0;
            auc.highestBidder= address(0);
            auc.ended= false;

            // auctions.push(auc);
        // auctions.push(newAuction);

        emit NewAuction(msg.sender, _itemName, auc.auctionEndTime);
    }

    function bid(uint auctionIndex) public payable {
        Auction storage auction = auctionss[auctionIndex];

        require(!auction.ended, "Auction has ended.");
        require(block.timestamp < auction.auctionEndTime, "Auction has ended.");
        require(msg.value > auction.highestBid, "Bid is too low.");

        if (auction.highestBidder != address(0)) {
            auction.bids[auction.highestBidder] += auction.highestBid;
        }

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        auction.bids[msg.sender] += msg.value;

        emit NewBid(auctionIndex, msg.sender, msg.value);
    }

    function endAuction(uint auctionIndex) public {
        Auction storage auction = auctionss[auctionIndex];

        require(!auction.ended, "Auction has already ended.");
        require(block.timestamp >= auction.auctionEndTime, "Auction has not yet ended.");

        auction.ended = true;
        auction.owner.transfer(auction.highestBid);

        emit AuctionEnded(auctionIndex, auction.highestBidder, auction.highestBid);
    }

    function getAuctionsCount() public view returns (uint) {
        return numRequests;
    }

    function getAuctionDetails(uint auctionIndex) public view returns (address, string memory, uint, uint, address, bool) {
        Auction storage auction = auctionss[auctionIndex];
        return (auction.owner, auction.itemName, auction.auctionEndTime, auction.highestBid, auction.highestBidder, auction.ended);
    }
}

