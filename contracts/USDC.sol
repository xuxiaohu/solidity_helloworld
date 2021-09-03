// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDC is ERC20 {
    string public constant NAME = "USDC";

    string public constant SYMBOL = "USDC";

    uint256 public constant INITIAL_SUPPLAY = 10000 * 1e18;

    constructor() ERC20(NAME, SYMBOL) {
        _mint(msg.sender, INITIAL_SUPPLAY);
    }
}
