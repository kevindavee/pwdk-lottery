//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is Ownable {
    uint256 public constant MINIMUM_AMOUNT = 0.1 ether;
    mapping(address => uint256) public playersBalance;
    address[] public playersAddress;

    function depositFund() public payable {
        require(msg.value >= MINIMUM_AMOUNT, "ether must higher or equal");

        playersBalance[msg.sender] += msg.value;

        bool exist = false;
        for (uint256 i = 0; i < playersAddress.length; i++) {
            if (playersAddress[i] == msg.sender) {
                exist = true;
            }
        }

        if (!exist) {
            playersAddress.push(msg.sender);
        }
    }

    function pickWinner() public onlyOwner {
        // Send all of the contract balance to the winner
        // - get random players
        // playerAddress = [A, B, C, D];
        // index = 0, 1, 2, or 3
        uint index = random() % playersAddress.length;
        address winnerAddress = playersAddress[index];

        // - send ether
        (bool sent, ) = winnerAddress.call{value: address(this).balance}("");
        require(sent, "Failed to sent ether to winner");


        // Reset all players balance to 0
        for (uint256 i = 0; i < playersAddress.length; i++) {
            playersBalance[playersAddress[i]] = 0;
        }
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, playersAddress.length)));
    }
}