// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.13;

// import {Script, console2} from "forge-std/Script.sol";
// import {Counter} from "../src/Counter.sol";

// contract CounterScript is Script {
//     function run() external {
//         uint256 privKey = vm.envUint("PRIV_KEY");
//         address deployer = vm.rememberKey(privKey);

//         console2.log("Deployer: ", deployer);
//         console2.log("Deployer Nonce: ", vm.getNonce(deployer));

//         vm.startBroadcast(deployer);

//         // Deploy Counter contract
//         Counter counter = new Counter();

//         // Set initial number
//         counter.setNumber(42);

//         // Increment number
//         counter.increment();

//         vm.stopBroadcast();

//         // Log deployment and interaction results
//         console2.log("Counter deployed at: ", address(counter));
//         console2.log("Current number: ", counter.number());
//     }
// }
