// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseTask.sol";

//Stores IPFS hashes instead of full model updates.
// Allows retrieval of hashes for aggregation.

contract TrainerNode is BaseTask {
    //Model updates that needs to be stored On Chain
    struct ModelRecord {
        uint taskId; // Task ID associated with the model
        string ipfsHash; // IPFS hash of the model update
        uint timestamp; // Time of submission
    }

    mapping(address => ModelRecord[]) public trainerModels;

    event ModelUpdateStored(
        uint taskId,
        address indexed trainer,
        string ipfsHash
    );

    // Function to store a model update as an IPFS hash
    function storeModelUpdate(uint taskId, string memory ipfsHash) internal {
        require(tasks[taskId].isActive, "task not active");
        Task storage task = tasks[taskId];
        require(
            task.stakes[msg.sender] >= TRAINER_STAKE,
            "Must be a staked trainer"
        );

        trainerModels[msg.sender].push(
            ModelRecord({
                taskId: taskId,
                ipfsHash: ipfsHash,
                timestamp: block.timestamp
            })
        );

        emit ModelUpdateStored(taskId, msg.sender, ipfsHash);
    }

    // Retrieve all models submitted by a trainer
    function getTrainerModels(
        address trainer
    ) public view returns (ModelRecord[] memory) {
        return trainerModels[trainer];
    }

    //Usage -
    //ModelRecord memory lastUpdate = trainerNode.getLastModelUpdate(trainerAddress);

    /**
     * @dev Retrieves the last model update of a trainer.
     * @param trainer The address of the trainer.
     * @return The last ModelRecord of the trainer.
     */
    function getLastModelUpdate(
        address trainer
    ) public view returns (ModelRecord memory) {
        require(
            trainerModels[trainer].length > 0,
            "No model updates found for this trainer"
        );
        return trainerModels[trainer][trainerModels[trainer].length - 1];
    }

    //Usage -
    //ModelRecord[] memory updatesAtTimestamp = trainerNode.getModelUpdatesByTimestamp(trainerAddress, specificTimestamp);

    /**
     * @dev Retrieves model updates of a trainer at a specific timestamp.
     * @param trainer The address of the trainer.
     * @param timestamp The exact timestamp to search for.
     * @return An array of ModelRecords matching the timestamp.
     */
    function getModelUpdatesByTimestamp(
        address trainer,
        uint timestamp
    ) public view returns (ModelRecord[] memory) {
        ModelRecord[] memory allModels = trainerModels[trainer];
        uint count = 0;

        // First, count the number of matching records
        for (uint i = 0; i < allModels.length; i++) {
            if (allModels[i].timestamp == timestamp) {
                count++;
            }
        }

        // Initialize a temporary array with the exact count
        ModelRecord[] memory matchingModels = new ModelRecord[](count);
        uint index = 0;

        // Populate the matchingModels array
        for (uint i = 0; i < allModels.length; i++) {
            if (allModels[i].timestamp == timestamp) {
                matchingModels[index] = allModels[i];
                index++;
            }
        }

        return matchingModels;
    }

    //Usage -
    //ModelRecord[] memory updatesWithHash = trainerNode.getModelUpdatesByHash(trainerAddress, specificHash);

    /*
        Access Control: Restrict certain retrieval functions to authorized
         entities (e.g., only the task creator or validators can retrieve specific model updates).
    */
    modifier onlyAuthorized(uint taskId) {
        require(
            tasks[taskId].creator == msg.sender, // || isValidator(msg.sender),
            "Not authorized"
        );
        _;
    }

    // Example usage
    //ModelRecord memory modelByHash = trainerNode.getModelUpdateByHash(trainerAddress, "QmSomeIpfsHash");

    /**
     * @dev Retrieves model updates of a trainer with a specific IPFS hash.
     * @param trainer The address of the trainer.
     * @param ipfsHash The specific IPFS hash to search for.
     * @return An array of ModelRecords matching the IPFS hash.
     */
    function getModelUpdatesByHash(
        address trainer,
        string memory ipfsHash
    ) public view returns (ModelRecord[] memory) {
        ModelRecord[] memory allModels = trainerModels[trainer];
        uint count = 0;

        // First, count the number of matching records
        for (uint i = 0; i < allModels.length; i++) {
            if (
                keccak256(bytes(allModels[i].ipfsHash)) ==
                keccak256(bytes(ipfsHash))
            ) {
                count++;
            }
        }

        // Initialize a temporary array with the exact count
        ModelRecord[] memory matchingModels = new ModelRecord[](count);
        uint index = 0;

        // Populate the matchingModels array
        for (uint i = 0; i < allModels.length; i++) {
            if (
                keccak256(bytes(allModels[i].ipfsHash)) ==
                keccak256(bytes(ipfsHash))
            ) {
                matchingModels[index] = allModels[i];
                index++;
            }
        }
        return matchingModels;
    }

    function getTrainerModelsPaginated(
        address trainer,
        uint start,
        uint count
    ) public view returns (ModelRecord[] memory) {
        uint total = trainerModels[trainer].length;

        // Return an empty array if the start index is out of bounds
        if (start >= total) {
            return new ModelRecord[](0);
        }

        // Calculate the end index, ensuring it doesn't exceed the total length
        uint end = start + count;
        if (end > total) {
            end = total;
        }

        // Determine the size of the result array
        uint size = end - start;
        ModelRecord[] memory paginated = new ModelRecord[](size);

        // Populate the paginated array
        for (uint i = 0; i < size; i++) {
            paginated[i] = trainerModels[trainer][start + i];
        }

        return paginated;
    }
}
