// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Token721 is ERC721,AccessControl  {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    constructor() ERC721("ERC721", "ERC721") {}

    function baseTokenURI() public view returns(string memory) {
      return "https://github.com/uni-arts-chain/uni-arts-service2";
    }
    
    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);

        return newItemId;
    }

    function _baseURI() internal view override returns(string memory) {
      return "https://github.com/uni-arts-chain/uni-arts-service/";
    }
    
  /**
  * override(ERC721, AccessControl) -> here you're specifying only two base classes ERC721, AccessControl
  * */
  function supportsInterface(bytes4 interfaceId)
      public
      view
      override(ERC721, AccessControl)
      returns (bool)
  {
      return super.supportsInterface(interfaceId);
  }
}
