// SPDX-License-Indentifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {

    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);

    }

      function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testTransfer() public {
        uint256 transferAmount = 10;
        uint256 previousBalances = ourToken.balanceOf(bob) + ourToken.balanceOf(alice);

        console.log(ourToken.balanceOf(msg.sender));
        vm.prank(bob);
        //ourToken.approve(alice, STARTING_BALANCE);
        ourToken.transfer(alice, transferAmount);
        assertEq(ourToken.balanceOf(bob), previousBalances - ourToken.balanceOf(alice));
        assertEq(ourToken.balanceOf(alice), transferAmount);

    }    



    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }


    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob); //address calling the transaction
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        //ourToken.transfer(alice, transferAmount); it will use the prank address as from 

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);

    }

}