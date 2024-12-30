// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//ensure the task creater stakes the required amount
import "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "./BaseTask.sol";

contract TaskManagement is BaseTask {
    // Event to log task creation
    event TaskCreated(uint id, string details, address creator, uint timestamp);

    function createTask(
        uint reward,
        uint stakeValue
    ) internal isCreatorRole(reward, stakeValue) {
        require(stakeValue >= reward, "reward must be deposited");
        require(
            stakeValue >= reward + CREATOR_STAKE,
            string(
                abi.encodePacked(
                    "Revert - Reward and stake must be deposited. Reward: ",
                    Strings.toString(reward),
                    " Stake: ",
                    Strings.toString(CREATOR_STAKE)
                )
            )
        );
        Task storage newTask = tasks[taskCounter];
        newTask.id = taskCounter;
        newTask.creator = msg.sender;
        newTask.reward = reward;
        newTask.totalstaked += CREATOR_STAKE; //can be more than required
        newTask.isActive = true; //should be set for specific time eventually

        emit TaskCreated((taskCounter), msg.sender, reward);
        taskCounter++;
    }

    modifier onlyTaskCreator(uint taskId) virtual {
        require(tasks[taskId].creator == msg.sender, "Not the task creator");
        _;
    }

    modifier isCreatorRole(uint reward, uint stakeValue) {
        require(
            stakeValue >= CREATOR_STAKE,
            "Insufficient stake for task creation"
        );
        require(
            stakeValue >= reward + CREATOR_STAKE,
            "Reward and stake must be deposited, currently reward is  {$reward} stake {$CREATOOR_STAKE} "
        );
        _;
    }

    // modifier onlyActiveTask(uint taskId) {
    //     require(tasks[taskId].isActive, "Task is not active");

    //     _;
    // }

    // Get incomplete tasks
    function getAvailableTasks()
        public
        view
        returns (
            uint[] memory,
            string[] memory,
            bool[] memory,
            address[] memory
        )
    {
        uint count = 0;

        // Count the number of incomplete tasks
        for (uint i = 0; i < taskCounter; i++) {
            if (tasks[i].isActive) {
                count++;
            }
        }
        uint[] memory ids = new uint[](count);
        string[] memory descriptions = new string[](count);
        bool[] memory isActiveFlags = new bool[](count);
        address[] memory assignedTos = new address[](count);

        uint index = 0;

        for (uint i = 0; i < taskCounter; i++) {
            if (tasks[i].isActive) {
                ids[index] = tasks[i].id;
                descriptions[index] = "assigned";
                isActiveFlags[index] = tasks[i].isActive;
                assignedTos[index] = tasks[i].creator;
                index++;
            }
        }

        return (ids, descriptions, isActiveFlags, assignedTos);
    }
    // Get task details by ID
    // function getTaskById(uint taskId) public view returns (Task memory) {
    //     require(taskId < nextTaskId, "Task ID does not exist");
    //     return taskById[taskId];
    // }

    // Get the last task added
    function getLastTask() public view returns (TaskSummary memory) {
        require(taskCounter > 0, "No tasks available");
        TaskSummary memory availableTasks = TaskSummary({
            id: tasks[taskCounter - 1].id,
            description: "assigned",
            isActive: tasks[taskCounter - 1].isActive,
            assignedTo: tasks[taskCounter - 1].creator
        });
        return availableTasks;
    }
}
