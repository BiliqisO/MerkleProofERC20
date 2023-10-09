// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";
import {MerkleToken} from "../contracts/MerkleToken.sol";

contract MerkleTest is Test {
    MerkleToken public merkleToken;
    bytes32 root;

    function setUp() public {
        root = 0x96af0c2fae069f9b01f02310bdd93634ed27b162d0ae24db1587a6258e1d01f2;
        merkleToken = new MerkleToken(root);
    }

    function testClaim() public {
        address acct1 = 0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C;
        bytes32[] memory proof = new bytes32[](3);
        proof[
            0
        ] = 0xc38db87582dda0be501d2042fb49e20f7a9fc98397ae63a6b46ea3e20ee61616;
        proof[
            1
        ] = 0x7423d6d83607b81ac8afcc31122377e2bc6acf0bed2da4e33e06fad8f625020b;

        proof[
            2
        ] = 0x47d79263b3efee4f4d9470121dcd87e2c20dbe7025531b813367b8ca7f3cc30a;
        merkleToken.claim(acct1, 10, proof);

        assertEq(
            merkleToken.balanceOf(0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C),
            10
        );
    }

    function testFailNotAllowedAddress() public {
        bytes32[] memory proof = new bytes32[](3);
        proof[
            0
        ] = 0xc38db87582dda0be501d2042fb49e20f7a9fc98397ae63a6b46ea3e20ee61616;
        proof[
            1
        ] = 0x7423d6d83607b81ac8afcc31122377e2bc6acf0bed2da4e33e06fad8f625020b;

        proof[
            2
        ] = 0x47d79263b3efee4f4d9470121dcd87e2c20dbe7025531b813367b8ca7f3cc30a;
        merkleToken.claim(address(1), 10, proof);
        assertEq(merkleToken.balanceOf(address(1)), 0);
    }

    function testFailBadProof() public {
        address acct1 = 0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C;
        bytes32[] memory proof = new bytes32[](3);
        proof[
            0
        ] = 0xc38db87582dda0be501d2042fb49e20f7a9fc98397ae63a6b46ea3e20ee61616;
        proof[
            1
        ] = 0x7423d6d83607b81ac8afcc31122377e2bc6acf0bed2da4e33e06fad8f625020b;

        proof[
            2
        ] = 0x49ac76360194e7eb3034deee26b2e080e6588a9c18e4d02580da7ac7fc426877;
        merkleToken.claim(acct1, 10, proof);

        assertEq(
            merkleToken.balanceOf(0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C),
            0
        );
    }

    function testFailClaimTwice() public {
        testClaim();
        testClaim();
        fail("Cant receive more than once");
    }
}
