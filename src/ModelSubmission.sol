// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseTask.sol";
// import "./Staking.sol";

contract ModelSubmission is BaseTask {
    function submitModelUpdate(uint taskId, bytes memory modelUpdate) internal {
        require(tasks[taskId].isActive, "Task is not active");
        Task storage task = tasks[taskId];
        require(task.stakes[msg.sender] >= TRAINER_STAKE, "Must be a staked trainer");

        task.modelUpdates[msg.sender] = modelUpdate;
        emit ModelSubmitted(taskId, msg.sender, modelUpdate);
    }
}