// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import '@openzeppelin/contracts/access/Ownable.sol';


contract AuctionToken is ERC20Pausable, Ownable {
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 1e18; 
    constructor() ERC20("Auction Token", "AuctionToken") {
      _mint(msg.sender, INITIAL_SUPPLY);
    }

    function pause() public onlyOwner {
      _pause();
    }

    function unpause() public onlyOwner {
      _unpause();
    }
}
