// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./MultiSigWallet.sol";

contract MultiSigWalletFactory {
    event WalletCreated(
        address indexed wallet,
        address[] owners,
        uint numConfirmationsRequired
    );

    function createWallet(
        address[] memory _owners,
        uint _numConfirmationsRequired
    ) public returns (address) {
        MultiSigWallet newWallet = new MultiSigWallet(
            _owners,
            _numConfirmationsRequired
        );
        emit WalletCreated(
            address(newWallet),
            _owners,
            _numConfirmationsRequired
        );
        return address(newWallet);
    }
}
