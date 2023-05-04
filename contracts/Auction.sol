// SPDX-License-Identifier: UNLICENSED

// pragma solidity ^0.8.18;

// contract Auction
// {
//     address public admin;
//     address payable public auctioneer;
   
//     uint public basePrice;
    

//     address public highestbidder;
//     uint public highestbid;

//     uint public auctionendtime;

//     mapping(address => uint) biddetails;
//     address payable[] biddersaddress;

//     bool public ended;

//     event HighestBidIncr(address bidder,uint bid);
//     event AuctionEnded(address winner,uint bid);

//     error auctionalreadyended(string str);
//     error bidnotminimum(uint bid,string message);
//     error auctionnotended(string s);
//     error endcalled(string s);
//     error notallowed(string s);

//     modifier checkended()
//     {
//         if(block.timestamp >= auctionendtime)
//         {
//             ended = true;
//         }
//         _;
//     }

//     modifier checkseller(address adminadr)
//     {
//         if(adminadr == auctioneer)
//         {
//             revert notallowed("this functionality is not for auctioneer");
//         }
//         _;
//     }

//     modifier checkowner(address adr)
//     {
//         if(adr == admin)
//         {
//             revert notallowed("this functionality is not allowed for Admin");
//         }
//         _;
//     }

//     modifier checknotowner(address adr)
//     {
//         if(adr !=admin)
//         {
//             revert notallowed("this functionalities is only for Admin");
//         }
//         _;
//     }

  

//     constructor()
//     {
//         admin = msg.sender;
//     }

//     function setAuctioneer(uint baseprice,uint duration) public checkowner(msg.sender){
       
//         auctioneer = payable(msg.sender);
//         basePrice = baseprice;
//         auctionendtime = block.timestamp + duration;
//         highestbidder = 0x0000000000000000000000000000000000000000;
//         highestbid=0;
//     }

  

//     function bid() external payable checkowner(msg.sender) checkseller(msg.sender) checkended() {
        
//         if(block.timestamp > auctionendtime)
//         {
//             revert auctionalreadyended("Auction has already ended");
//         }
//         if(biddetails[msg.sender]+msg.value < basePrice)
//         {
//             revert bidnotminimum(basePrice,"minimum bid a needed");
//         }
//         if((biddetails[msg.sender]+msg.value) <= highestbid)
//         {
//             revert bidnotminimum(highestbid,"minimum bid needed");
//         }
//         if(highestbid !=0)
//         {
//             biddetails[highestbidder] +=highestbid;
//         }

//         highestbidder = msg.sender;
//         highestbid = biddetails[highestbidder] + msg.value;
//         biddersaddress.push(payable(msg.sender));
//         emit HighestBidIncr(msg.sender,msg.value);
//     }


//     function withdraw() external checkowner(msg.sender) checkseller(msg.sender) checkended() returns(bool)
//     {
//         uint amount = biddetails[msg.sender];
//         if(amount>0)
//         {
//             biddetails[msg.sender] = 0;
//             if(!payable(msg.sender).send(amount))
//             {
//                 biddetails[msg.sender] = amount;
//                 return false;
//             }
//         }
//         return true;
//     }

//     function auctionend()  external
//     {
//         if(block.timestamp < auctionendtime)
//         {
//             revert auctionnotended("auction is not ended yet");
//         }
//         if(ended)
//         {
//             revert endcalled("end auction already called");
//         }

//         ended = true;
//         auctioneer.transfer(highestbid);
//         for(uint i=0;i<biddersaddress.length;i++)
//         {
//             if(biddersaddress[i] != highestbidder)
//             {
//                 biddersaddress[i].transfer(biddetails[biddersaddress[i]]);
//             }
//         }
//         emit AuctionEnded(highestbidder,highestbid);

        
//     }

//     function cancelauction() external checknotowner(msg.sender) checkseller(msg.sender) checkended()
//     {
//         if(block.timestamp > auctionendtime)
//         {
//             revert auctionalreadyended("auciton has already ended");
//         }
//         for(uint i=0;i<biddersaddress.length;i++)
//         {
//             // biddetails[biddersaddress[i]].transfer(biddetails)
//             biddersaddress[i].transfer(biddetails[biddersaddress[i]]);
//         }
//     }

// }


pragma solidity ^0.8.18;

contract Auction
{
    address public admin;
    address payable public auctioneer;
   
    uint public basePrice;
    

    address public highestbidder;
    uint public highestbid;

    uint public auctionendtime;

    mapping(address => uint) biddetails;
    address payable[] biddersaddress;

    bool public ended;

    event HighestBidIncr(address bidder,uint bid);
    event AuctionEnded(address winner,uint bid);

    error auctionalreadyended(string str);
    error bidnotminimum(uint bid,string message);
    error auctionnotended(string s);
    error endcalled(string s);
    error notallowed(string s);

    modifier checkseller(address adminadr)
    {
        if(adminadr == auctioneer)
        {
            revert notallowed("this functionality is not for auctioneer");
        }
        _;
    }

    modifier checkowner(address adr)
    {
        if(adr == admin)
        {
            revert notallowed("this functionality is not allowed for Admin");
        }
        _;
    }

    modifier checknotowner(address adr)
    {
        if(adr !=admin)
        {
            revert notallowed("this functionalities is only for Admin");
        }
        _;
    }

  

    constructor()
    {
        admin = msg.sender;
    }

    function setAuctioneer(uint baseprice,uint duration) public checkowner(msg.sender){
       
        auctioneer = payable(msg.sender);
        basePrice = baseprice;
        auctionendtime = block.timestamp + duration;
        highestbidder = 0x0000000000000000000000000000000000000000;
        highestbid=0;
    }

  

    function bid() external payable checkowner(msg.sender) checkseller(msg.sender) {
        
        if(block.timestamp > auctionendtime)
        {
            revert auctionalreadyended("Auction has already ended");
        }
        if(biddetails[msg.sender]+msg.value < basePrice)
        {
            revert bidnotminimum(basePrice,"minimum bid a needed");
        }
        if((biddetails[msg.sender]+msg.value) <= highestbid)
        {
            revert bidnotminimum(highestbid,"minimum bid needed");
        }
        if(highestbid !=0)
        {
            biddetails[highestbidder] +=highestbid;
        }

        highestbidder = msg.sender;
        highestbid = biddetails[highestbidder] + msg.value;
        biddersaddress.push(payable(msg.sender));
        emit HighestBidIncr(msg.sender,msg.value);
    }


    function withdraw() external checkowner(msg.sender) checkseller(msg.sender) returns(bool)
    {
        uint amount = biddetails[msg.sender];
        if(amount>0)
        {
            biddetails[msg.sender] = 0;
            if(!payable(msg.sender).send(amount))
            {
                biddetails[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionend() external
    {
        if(block.timestamp < auctionendtime)
        {
            revert auctionnotended("auction is not ended yet");
        }
        if(ended)
        {
            revert endcalled("end auction already called");
        }

        ended = true;
        auctioneer.transfer(highestbid);
        for(uint i=0;i<biddersaddress.length;i++)
        {
            if(biddersaddress[i] != highestbidder)
            {
                biddersaddress[i].transfer(biddetails[biddersaddress[i]]);
            }
        }
        emit AuctionEnded(highestbidder,highestbid);

        
    }

    function cancelauction() external checknotowner(msg.sender) checkseller(msg.sender)
    {
        if(block.timestamp > auctionendtime)
        {
            revert auctionalreadyended("auciton has already ended");
        }
        for(uint i=0;i<biddersaddress.length;i++)
        {
            // biddetails[biddersaddress[i]].transfer(biddetails)
            biddersaddress[i].transfer(biddetails[biddersaddress[i]]);
        }
    }

}