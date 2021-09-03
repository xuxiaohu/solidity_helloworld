// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Vault {
    address payable owner;

    function initialize(address payable _owner) public {
        owner = _owner;
    }

    function withdraw() public {
        require(owner == msg.sender);
        owner.transfer(address(this).balance);
    }
}
