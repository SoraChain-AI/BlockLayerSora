// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TaskManagement.sol";
import "./RoleBasedAccess.sol";

//implements a role based stacking mechanism
/*Task Creator stakes at least CREATOR_STAKE while creating the task.
Trainer Nodes stake TRAINER_STAKE when joining as trainers.
Aggregator stakes AGGREGATOR_STAKE during the aggregation phase.
*/

/*
To-Do
*Trainer can unstake  to asign trainer to different task
*Task Creater can unstake and mark it as complete
*/

contract Staking is TaskManagement, RoleBasedAccess {
    // enum Role {
    //     None,
    //     TaskCreator,
    //     Aggregrator,
    //     Trainer
    // }

    // Mapping to store roles by address
    // mapping(address => Role) public roles;

    // uint public constant MINIMUM_STAKE = 1 ether;

    function stakeTokens(
        uint taskID,
        Role role
    )
        public
        payable
        onlyActiveTask(taskID)
        hasToken(role)
        hasNotStackedEarlier(taskID)
    {
        Task storage task = tasks[taskID];
        task.stakes[msg.sender] = msg.value;
        task.totalstaked += msg.value;
        if (role == Role.TrainerNode) {
            task.trainers.push(msg.sender);
        }
    }

    modifier hasToken(Role role) {
        require(msg.value != 0, "Stake Tokens not found");
        if (role == Role.TaskCreator) {
            require(msg.value >= CREATOR_STAKE);
        } else if (role == Role.Aggregator) {
            require(msg.value >= AGGREGATOR_STAKE);
        } else if (role == Role.TrainerNode) {
            require(msg.value >= TRAINER_STAKE);
        } else {
            revert("Invalid Role");
        }
        _;
    }

    modifier hasNotStackedEarlier(uint taskID) {
        require(
            tasks[taskID].stakes[msg.sender] == 0,
            "Already stacked for the task"
        );
        _;
    }
}
