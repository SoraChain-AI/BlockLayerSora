// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//implements aggregrator staking for future node
//if aggregrator and validator are seperate entities
//we use this contract else for testnet
//Single entity acts as task creator,aggregrator and validator

import "./BaseTask.sol";
import "./TrainerNode.sol";

contract AggregationAndValidation is BaseTask {
    address aggregratorAddress;
    TrainerNode public trainerNodeContract;

    // constructor(address trainerNodeAddress) {
    //     trainerNodeContract = TrainerNode(trainerNodeAddress);
    // }

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
    event AggregatedModelStored(uint taskId, string ipfsHash);

    // Function to aggregate model updates based on IPFS hashes
    function aggregateAndValidate(
        uint taskId
    ) public onlyTaskCreator(taskId) onlyActiveTask(taskId) {
        Task storage task = tasks[taskId];
        require(task.trainers.length > 0, "No trainers for this task");

        // Example aggregation: Concatenate all hashes (real logic depends on your aggregation mechanism)
        string memory aggregatedModelHash;

        for (uint i = 0; i < task.trainers.length; i++) {
            address trainer = task.trainers[i];
            TrainerNode.ModelRecord[] memory models = trainerNodeContract
                .getTrainerModels(trainer);

            for (uint j = 0; j < models.length; j++) {
                if (models[j].taskId == taskId) {
                    // Combine IPFS hashes for aggregation (custom logic applies here)
                    aggregatedModelHash = string(
                        abi.encodePacked(
                            aggregatedModelHash,
                            models[j].ipfsHash
                        )
                    );
                }
            }
        }

        task.isActive = false;

        // Store the aggregated model hash on-chain
        // trainerNodeContract.storeModelUpdate(taskId, aggregatedModelHash);

        emit AggregatedModelStored(taskId, aggregatedModelHash);

        // Distribute rewards to trainers
        distributeRewards(taskId);
    }

    modifier onlyTaskCreator(uint taskId) virtual {
        require(tasks[taskId].creator == msg.sender, "Not the task creator");
        _;
    }

    function distributeRewards(uint taskId) private {
        Task storage task = tasks[taskId];
        uint rewardPerTrainer = task.reward / task.trainers.length;

        for (uint i = 0; i < task.trainers.length; i++) {
            address trainer = task.trainers[i];
            payable(trainer).transfer(rewardPerTrainer);
            emit RewardDistributed(taskId, trainer, rewardPerTrainer);
        }
    }
}
