// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MouadToken} from "../src/MouadToken.sol";

contract DeployMouadToken is Script {
    uint256 public constant INITIAL_SUPLY = 1000 ether;

    function run() external returns (MouadToken) {
        vm.startBroadcast();
        MouadToken mouadToken = new MouadToken(INITIAL_SUPLY);
        vm.stopBroadcast();
        return mouadToken;
    }
}
