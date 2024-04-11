// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployMouadToken} from "../script/DeployMouadToken.s.sol";
import {MouadToken} from "../src/MouadToken.sol";

contract MouadTokenTest is Test {
    DeployMouadToken public deployer;
    MouadToken public mouadToken;

    uint256 public STARTING_BALANCE = 100 ether;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployMouadToken();
        mouadToken = deployer.run();

        vm.prank(msg.sender);
        mouadToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, mouadToken.balanceOf(bob));
    }

    function testAllowanceWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        mouadToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        mouadToken.transferFrom(bob, alice, transferAmount);

        assertEq(mouadToken.balanceOf(alice), transferAmount);
        assertEq(mouadToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransfer() public {
        uint256 transferAmount = 50 ether;
        vm.prank(bob);
        mouadToken.transfer(alice, transferAmount);
        assertEq(mouadToken.balanceOf(alice), transferAmount);
        assertEq(mouadToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTransferFailInsufficientBalance() public {
        vm.expectRevert();
        uint256 transferAmount = STARTING_BALANCE + 1;
        mouadToken.transfer(alice, transferAmount);
    }

    function testApproveAndTransferFromFailInsufficientAllowance() public {
        uint256 initialAllowance = 100;

        vm.prank(bob);
        mouadToken.approve(alice, initialAllowance);

        vm.expectRevert();
        uint256 transferAmount = initialAllowance + 1;
        mouadToken.transferFrom(bob, alice, transferAmount);
    }

    function testDecimals() public {
        uint8 expectedDecimals = 18;
        assertEq(mouadToken.decimals(), expectedDecimals);
    }

    function testSymbol() public {
        string memory expectedSymbol = "MT";
        assertEq(
            keccak256(bytes(mouadToken.symbol())),
            keccak256(bytes(expectedSymbol))
        );
    }

    function testName() public {
        string memory expectedName = "MouadToken";
        assertEq(
            keccak256(bytes(mouadToken.name())),
            keccak256(bytes(expectedName))
        );
    }
}
