// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MultiSigWallet} from "../src/MultiSigWallet.sol";
import {MultiSigWalletFactory} from "../src/MultiSigWalletFactory.sol";

contract MultiSigWalletTest is Test {
    MultiSigWallet public wallet;
    MultiSigWalletFactory public factory;
    address[] public owners;
    uint256 public numConfirmationsRequired;

    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    event WalletCreated(
        address indexed wallet,
        address[] owners,
        uint numConfirmationsRequired
    );

    function setUp() public {
        owners = new address[](3);
        owners[0] = address(this);
        owners[1] = address(0x1);
        owners[2] = address(0x2);
        numConfirmationsRequired = 2;

        factory = new MultiSigWalletFactory();
        wallet = MultiSigWallet(
            payable(factory.createWallet(owners, numConfirmationsRequired))
        );
    }

    function testWalletCreation() public view {
        assertEq(wallet.getOwners(), owners);
        assertEq(wallet.numConfirmationsRequired(), numConfirmationsRequired);
    }

    function testOnlyOwnerCanSubmitTransaction() public {
        vm.prank(address(0x3));
        vm.expectRevert("not owner");
        wallet.submitTransaction(address(0x4), 1 ether, "");
    }

    function testSubmitTransaction() public {
        vm.prank(owners[0]);
        vm.expectEmit(true, true, true, true);
        emit SubmitTransaction(owners[0], 0, address(0x4), 1 ether, "");
        wallet.submitTransaction(address(0x4), 1 ether, "");

        (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numConfirmations
        ) = wallet.getTransaction(0);
        assertEq(to, address(0x4));
        assertEq(value, 1 ether);
        assertEq(data, "");
        assertEq(executed, false);
        assertEq(numConfirmations, 0);
    }

    function testConfirmTransaction() public {
        vm.prank(owners[0]);
        wallet.submitTransaction(address(0x4), 1 ether, "");

        vm.prank(owners[1]);
        vm.expectEmit(true, true, false, true);
        emit ConfirmTransaction(owners[1], 0);
        wallet.confirmTransaction(0);

        (, , , , uint numConfirmations) = wallet.getTransaction(0);
        assertEq(numConfirmations, 1);
    }

    function testExecuteTransaction() public {
        vm.deal(address(wallet), 2 ether);

        vm.prank(owners[0]);
        wallet.submitTransaction(address(0x4), 1 ether, "");

        vm.prank(owners[0]);
        wallet.confirmTransaction(0);

        vm.prank(owners[1]);
        wallet.confirmTransaction(0);

        vm.prank(owners[2]);
        vm.expectEmit(true, true, false, true);
        emit ExecuteTransaction(owners[2], 0);
        wallet.executeTransaction(0);

        (, , , bool executed, ) = wallet.getTransaction(0);
        assertEq(executed, true);
        assertEq(address(0x4).balance, 1 ether);
    }

    function testRevokeConfirmation() public {
        vm.prank(owners[0]);
        wallet.submitTransaction(address(0x4), 1 ether, "");

        vm.prank(owners[1]);
        wallet.confirmTransaction(0);

        vm.prank(owners[1]);
        vm.expectEmit(true, true, false, true);
        emit RevokeConfirmation(owners[1], 0);
        wallet.revokeConfirmation(0);

        (, , , , uint numConfirmations) = wallet.getTransaction(0);
        assertEq(numConfirmations, 0);
    }

    function testDepositEmitsEvent() public {
        vm.expectEmit(true, false, false, true);
        emit Deposit(address(this), 1 ether, 1 ether);
        (bool success, ) = address(wallet).call{value: 1 ether}("");
        require(success, "Deposit failed");
    }

    //Function to see if the function fails when a address that is not an owner tries to submit a transaction
    function testNonOwnerSubmitTransaction() public {
        vm.prank(address(0x3));
        vm.expectRevert("not owner");
        wallet.submitTransaction(address(0x4), 1 ether, "");
    }
}
