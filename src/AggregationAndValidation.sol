// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//implements aggregrator staking for future node
//if aggregrator and validator are seperate entities
//we use this contract else for testnet
//Single entity acts as task creator,aggregrator and validator

import "./BaseTask.sol";

contract AggrgrationAndValidation is BaseTask {
    address aggregratorAddress;

    function stakeAsAggregrator(uint taskID) public payable {
        require(tasks[taskID].isActive, "Task is not active");
        require(
            aggregratorAddress == address(0),
            "Aggregator already assigned"
        );
        require(
            msg.value >= AGGREGATOR_STAKE,
            "Insufficient stake for aggregator"
        );
        Task storage task = tasks[taskID];

        task.stakes[msg.sender] = msg.value;
        task.totalstaked += msg.value;
        aggregratorAddress = msg.sender;


    }

    //add aggregration logic for blockchain layer
}
