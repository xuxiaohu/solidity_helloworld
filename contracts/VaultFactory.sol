// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Vault.sol";
import "@openzeppelin/contracts/utils/Create2.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract VaultFactory {
    event VaultCreated(address vault);

    function deployVault(bytes32 salt, address payable owner) public {
        address vaultAddress;

        vaultAddress = Create2.deploy(10, salt, type(Vault).creationCode);
        Vault(vaultAddress).initialize(owner);

        emit VaultCreated(vaultAddress);
    }

    function computeAddress(bytes32 salt) public view returns (address) {
        bytes memory _code = type(Vault).creationCode;
        return Create2.computeAddress(salt, keccak256(_code));
    }

    function sendValue(bytes32 salt) external payable {
        address vaultAddress;

        bytes memory _code = type(Vault).creationCode;
        vaultAddress = Create2.computeAddress(salt, keccak256(_code));

        Address.sendValue(payable(vaultAddress), msg.value);
    }
}
