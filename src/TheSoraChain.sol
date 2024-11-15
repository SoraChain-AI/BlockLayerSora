// //// SPDX-License-Identifier: MIT
// pragma solidity <0.9.0;

// import {console} from  "forge-std/console.sol";

// contract TheSoraChain{
    
//     event  subNetRegisterd(address subnetOwner, uint subnetID);
    
//     address minter;
//     mapping(address => uint) balances;
//     address[] subnets;
    
//     uint stackingAmount;

//     constructor(){
//         minter = msg.sender;
//         stackingAmount =10;
//     }

//     modifier onlyContractOwner(){
//         require(msg.sender == minter);
//         _;
//     }
//     function setStackingAmount(uint value) onlyContractOwner() public {
//         stackingAmount = value;
//     } 

//     function registerSubNetOwner() public payable{
//         require(msg.sender != minter,"contract owner can not register subnet");        
//         console.log("counting subnets length %d" , subnets.length);
//         for (uint256 index = 0; index < subnets.length; index++) {
//             console.log("counting subnets");
//             require(subnets[index]!= msg.sender,"subnetalready regisiterd");
//             console.log("subnets checked");
//         }
//         require(msg.value> stackingAmount );
//         console.log("stacking confirmed,pushing" );
//         subnets.push(msg.sender);
//         emit subNetRegisterd(msg.sender, subnets.length -1);
        
//     }
// }