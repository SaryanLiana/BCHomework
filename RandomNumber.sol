// SPDX-License-Identifier: MIT

pragma solidity ^0.8.11;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

/**
* @title RandomNumber
* @dev this contract checks if the input number is in the epsilon neighborhood of a random number or not.
* If the number is in epsilon neighborhood congratulates to user.
* Note: This contract will work only for Goerli test network.
*/
contract RandomNumber is VRFConsumerBase {

    string success = "Congratulations, you won!";
    string failure = "Thank you for playing!"; 

    uint256  eps = 5;

    bytes32 internal keyHash; // identifies which Chainlink oracle to use
    uint internal fee;        // fee to get random number
    uint public randomResult;

    constructor()
        VRFConsumerBase(
            0x2bce784e69d2Ff36c71edcB9F88358dB0DfB55b4, // VRF coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK token address
        ) {
            keyHash = 0x0476f9a745b61ea5c0ab224d3a6e4c99f0b02fce4da01143a4f70aa80ae76e8a;
            fee = 0.1 * 10 ** 18;    // 0.1 LINK

    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK in contract");
        return requestRandomness(keyHash, fee);
    }

    /**
    * @dev generates random number using Chainlink VRF.
    * @param requestId return value of getRandomNumber() function.
    * @return randomness random number that generate Chainlink VRF.
    */
    function fulfillRandomness(bytes32 requestId, uint randomness) internal override {
        randomResult = randomness % 100;
    }

    /**
    * @dev checks if user's number is in the epsilon neighborhood of a random number or not.
    * @param _number number that user entered.
    */
    function checkTheProximity(uint256 _number) public view returns(string memory) {
        if(randomResult > _number) {
            if(randomResult - _number < eps) {
                return success;
            }
            return failure;
        }
        else {
            if(_number - randomResult < eps) {
                return success;
            }
            return failure;
        }
    }
}