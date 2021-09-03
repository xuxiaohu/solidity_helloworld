// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract Auction is ReentrancyGuard{

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address public USDC_ADDRESS;
    address public TOKEN_ADDRESS;
    
    struct MarketInfo {
        uint256 auctionId;
        uint256 startTime;
        uint256 endTime;
        uint256 totalTokens;
        uint256 startPrice;
        uint256 minimumPrice;
        uint256 currentPrice;
    }

    struct BidHistory {
        uint256 auctionId;
        uint256 blockNumber;
        address bidder;
        uint256 price;
    }

    MarketInfo[] private market_infos;
    mapping(uint256 => BidHistory[]) private bid_histories;

    constructor(address usdcAddress, address auctionTokenAddress) {
        USDC_ADDRESS = usdcAddress;
        TOKEN_ADDRESS = auctionTokenAddress;
    }

    function createAuction(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _startPrice,
        uint256 _minimumPrice,
        uint256 _totalTokens
    ) external nonReentrant{
        require(_startTime < 10000000000, "Auction: enter an unix timestamp in seconds, not miliseconds");
        require(_endTime < 10000000000, "Auction: enter an unix timestamp in seconds, not miliseconds");
        require(_startTime >= block.timestamp, "Auction: start time is before current time");
        require(_endTime > _startTime, "Auction: end time must be older than start price");
        require(_totalTokens > 0,"Auction: total tokens must be greater than zero");
        require(_minimumPrice > 0, "Auction: minimum price must be greater than 0"); 
        require(_startPrice > 0, "Auction: start price must be greater than 0");
        address _this = address(this);
        IERC20 _token = IERC20(TOKEN_ADDRESS);
        uint total_amount = _token.balanceOf(msg.sender);
        require(total_amount >= _totalTokens, "Auction: has amount must be less then total token");
        _token.transferFrom(msg.sender, _this, _totalTokens);
        uint256 auction_id = market_infos.length + 1;
        MarketInfo memory market_info = MarketInfo({
          auctionId: auction_id,
          startTime: _startTime,
          endTime:  _endTime,
          startPrice: _startPrice,
          minimumPrice: _minimumPrice,
          totalTokens: _totalTokens,
          currentPrice: 0
        });
        market_infos.push(market_info);
    }

    function getCurrentPrice(uint256 auctionId) public view returns (uint256 price) {
      require(auctionId > 0 && auctionId <= market_infos.length, "Auction: auctionId outof range");
      MarketInfo memory market_info = market_infos[auctionId - 1];
      price = market_info.currentPrice;
    }

    function bidAuction(uint256 auctionId) external nonReentrant {
      require(auctionId > 0 && auctionId <= market_infos.length, "Auction: auctionId outof range");
      MarketInfo memory market_info = market_infos[auctionId - 1];
      require(market_info.startTime >= block.timestamp && market_info.endTime < block.timestamp, "Auction: auction time wrong");
      uint256 price = market_info.currentPrice;
      if (price == 0) {
        market_info.currentPrice = market_info.startPrice;
      } else {
        market_info.currentPrice = market_info.startPrice.add(market_info.minimumPrice);
      }
      bid_histories[auctionId].push(BidHistory({
        auctionId: auctionId,
        blockNumber: block.number,
        bidder: msg.sender,
        price: market_info.currentPrice
      }));
    }

    function winAuction(uint256 auctionId) external nonReentrant {
      require(auctionId > 0 && auctionId <= market_infos.length, "Auction: auctionId outof range");
      MarketInfo memory market_info = market_infos[auctionId - 1];
      require(market_info.endTime > block.timestamp, "Auction: auction time wrong");
      BidHistory[] memory _bid_histories = bid_histories[auctionId];
      require(_bid_histories.length > 0, "Auction: no bid");
      BidHistory memory last_bid = _bid_histories[_bid_histories.length - 1];
      address winner = last_bid.bidder;
      IERC20 _token = IERC20(TOKEN_ADDRESS);
       _token.safeTransferFrom(address(this), winner, market_info.totalTokens);
    }
}
