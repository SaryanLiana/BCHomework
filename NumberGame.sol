// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

/**
* @title NumberGame
* @dev this contract checks if the input number is in the epsilon neighborhood of a random number or not.
* If the number is in epsilon neighborhood gives points to the user as a reward.
*/
contract NumberGame {

    struct Users {
        string name;
        string surename;
        uint userPoint;
    }

    mapping(address => Users) public rewardPart;

    uint eps = 5;
    
    /**
    * @dev checks if user's number is in the epsilon neighborhood of a random number or not.
    * @param _num number that user entered.
    */
    function checkRandomNumber(uint _num) public {

        uint randomnum = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % _num;

        if(randomnum > _num - eps || randomnum < _num + eps){
            rewardPart[msg.sender].userPoint += 10;
        }
    }
}