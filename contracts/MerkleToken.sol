// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleToken is ERC20 {
    bytes32 public root;

    mapping(address => bool) received;

    constructor(bytes32 _root) ERC20("merkleToken", "MT") {
        _mint(msg.sender, 1_000_000_000e18);
        root = _root;
    }

    function transfer(address to, uint value, bytes32[] memory proof) public {
        require(!received[to], "already received");
        //verify the leaf if in tree
        bytes32 leaf = keccak256(abi.encodePacked(to, value));
        bool isValid = MerkleProof.verify(proof, root, leaf);
        require(!isValid, "You are not allowed to receive tokens");
        received[to] = true;
        transfer(to, value);
    }
}
