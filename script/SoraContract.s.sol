// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "./../src/BaseTask.sol";
import "./../src/RoleBasedAccess.sol";

import "./../src/TaskManagement.sol";
import "./../src/ModelSubmission.sol";
import "./../src/Staking.sol";
import "./../src/AggregationAndValidation.sol";
import {SoraContract} from "./../src/SoraContract.sol";

contract DeploySoraContract is Script {
    SoraContract public S_Contract;

    function run() external returns (SoraContract) {
        vm.startBroadcast();

        SoraContract chain = new SoraContract();
        vm.stopBroadcast();
        return chain;
    }
}
