// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4; 

/** We are creating a lottery smart contract. SO what are we considering:
1. An only manager function
2. Declaring an address of arrays to collect all the addresses involved in the lottery
3. Consider mapping addresses to the amount of ether deposited, to keep tract of tokens deposited for the lottery
4. Declare a function that can generate random winners during the contest.
5. create a function to get the balance of the lottery contract.
6. Require that the only person that can transfer is the manager;
7. Require that the length of the lottery players is 10

*/
contract lottery {
    address payable[] public lotteryPlayers;
    mapping(address => uint) depositBalance;
    address public manager;

    receive() external payable {
        
        
    }

    fallback() external payable {
        
    }

    constructor() {
        manager = msg.sender;
    }

    function getBalance() public view returns(uint) {
        require (msg.sender == manager, "Not the Manager");
        return address(this).balance;
        
        }
    function depositLottery() public payable returns(uint) {
        require(depositBalance[msg.sender] >= 1 ether, "Insufficient Balance");
        lotteryPlayers.push(payable(msg.sender));
        return depositBalance[msg.sender] += msg.value;
    }

    function randomPlayers() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, lotteryPlayers.length)));
    }

    function transferLottery() public {
        require (msg.sender == manager, "Not the Manager");
        require(lotteryPlayers.length >= 10, "Players should be at least 10");
        // require(msg.value >= 1.5 ether, "Insufficient Transfer Balance");

        uint randomLottery = randomPlayers();
        address payable lotteryWinner;

         uint index = randomLottery % lotteryPlayers.length;
        
        lotteryWinner = lotteryPlayers[index];
        lotteryWinner.transfer(getBalance());
         lotteryPlayers = new address payable[](0);

    }


    





}