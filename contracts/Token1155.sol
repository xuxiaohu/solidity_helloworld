// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "@openzeppelin/contracts/utils/Counters.sol";

contract Token1155 is Ownable, ERC1155 {
    using Counters for Counters.Counter;
    mapping(string => uint256)  private nameTokenId;
    Counters.Counter private _tokenIds;

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
      _setOwner(_msgSender());
    }

    function createItem(string memory name, uint256 memory totalSupply)  external onlyOwner{
        uint256 newItemId = _tokenIds.current();
        nameTokenId[name] = newItemId;
        _mint(msg.sender, newItemId, totalSupply, "");
    }

    function getTokenId(string memory name) public view returns (uint256) {
        return nameTokenId[name];
    }
}
