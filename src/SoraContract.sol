// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseTask.sol";
import "./RoleBasedAccess.sol";
import "./TaskManagement.sol";
import "./Staking.sol";
import "./ModelSubmission.sol";
import "./TrainerNode.sol";
import "./AggregationAndValidation.sol";

contract SoraContract is
    TaskManagement,
    Staking,
    ModelSubmission,
    AggregationAndValidation,
    TrainerNode
{
    address minter;
    mapping(address => uint) balances;
    address[] subnets;

    // uint stackingAmount;

    constructor() {
        minter = msg.sender;
        // stackingAmount =10;
    }

    modifier onlyContractOwner() {
        require(msg.sender == minter);
        _;
    }

   modifier onlyTaskCreator(uint taskId)
    override(AggregationAndValidation, TaskManagement){
    // You can combine or redefine the logic here
        require(tasks[taskId].creator == msg.sender, "Not the task creator");
        _;
}

}
