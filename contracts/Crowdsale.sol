// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Crowdsale is ReentrancyGuard{
    using SafeMath for uint256;
    using SafeERC20 for ERC20;
    ERC20 public token;
    address payable public  wallet;
    uint256 public rate = 10;
    uint256 public total_amount = 10000 * 1e18;

    constructor(ERC20 _token, address payable _wallet) {
        token = _token;
        wallet = _wallet;
    }

    function buyTokens() external payable nonReentrant{
        uint256 weiAmount = msg.value;
        token.safeTransfer(msg.sender, rate.mul(weiAmount));
        wallet.transfer(weiAmount);
    }
}
