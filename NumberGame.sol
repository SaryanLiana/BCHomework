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

    string success = "Congratulations, you won!";
    string failure = "Thank you for playing!"; 
    
    mapping(address => Users) public rewardPart;

    uint eps = 5;
    uint256 public randomNum;
    
    /**
    * @dev generates random number.
    * @param _num number that user entered.
    * @return randomNum number between 0 and _num.
    */
    function getRandomNumber(uint256 _num) public returns(uint256) {
        return randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % _num;
    }

    /**
    * @dev checks if user's number is in the epsilon neighborhood of a random number or not.
    * @param _number number that user entered.
    */
    function checkTheProximity(uint256 _number) public returns(string memory) {
        if(randomNum > _number) {
            if(randomNum - _number < eps) {
                rewardPart[msg.sender].userPoint += 10;
                return success;
            }
            return failure;
        }
        else {
            if(_number - randomNum < eps) {
                rewardPart[msg.sender].userPoint += 10;
                return success;
            }
            return failure;
        }
    }
}