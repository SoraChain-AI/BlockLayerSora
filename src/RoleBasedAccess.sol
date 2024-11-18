// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;
pragma solidity ^0.8.0;

contract RoleBasedAccess {
    // Define roles
    enum Role {
        None, // Default role
        TaskCreator,
        Aggregator,
        TrainerNode
    }

    // Mapping to store roles by address
    mapping(address => Role) public roles;

    // OnlyOwner modifier (replace with your own ownership logic)
    address public owner;

    constructor() {
        owner = msg.sender; // Contract deployer is the initial owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Assign roles
    // function assignRole(address user, Role role) public onlyOwner {
    //     roles[user] = role;
    // }

    function assignStackedRole(address user, Role role) public {
        roles[user] = role;
    }

    // Get role for the caller
    function getMyRole() public view returns (string memory) {
        Role role = roles[msg.sender];

        if (role == Role.TaskCreator) {
            return "TaskCreator";
        } else if (role == Role.Aggregator) {
            return "Aggregator";
        } else if (role == Role.TrainerNode) {
            return "TrainerNode";
        } else {
            return "None";
        }
    }

     // Check if an address is a TaskCreator
    function isTaskCreator(address user) public view returns (bool) {
        return roles[user] == Role.TaskCreator;
    }
}
