// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

/**
* @title Shareholder
* @dev this contract adds and removes users by the owner and sends users
* ether according to their percentage for not keeping ether in the contract 
*/
contract Shareholder {

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(owner == msg.sender, "TestingReceive: Not owner");
        _;
    }

    address owner;
    mapping(address => uint256) public userToPercent;
    address payable[] public users;
    uint256 public total;

    /**
    * The constructor initializes the owner.
    */
    constructor(address _owner) {
        owner = _owner;
    }

    /**
    * @dev sends ethers to users corresponding to their percentage.
    */
    receive() external payable {
        for(uint256 _index; _index < users.length; _index++) {
            users[_index].transfer((address(this).balance * userToPercent[users[_index]]) / 100);
        }
    }

    /**
    * @dev adds users.
    * Note: the use of onlyOwner ensures that this function can call only owner.
    * @param _userAddress the address of the user that should be added.
    * @param _percentage the percentage that the user should receive from the amount.
    */
    function addUsers(address payable _userAddress, uint256 _percentage) public onlyOwner {
        require(total + _percentage <= 100, "total greater than 100");
        if(userToPercent[_userAddress] == 0) {
            users.push(_userAddress);
        } 

        if(userToPercent[_userAddress] > _percentage){
            total -= (userToPercent[_userAddress] - _percentage);
        } else {
            total += (_percentage - userToPercent[_userAddress]);
        }
 
        userToPercent[_userAddress] = _percentage; 
    }

    /**
    * @dev removes users.
    * Note: the use of onlyOwner ensures that this function can call only owner.
    * @param _userAddress the address of the user that should be removed.
    */
    function removeUsers(address _userAddress) public onlyOwner {
        for(uint256 _index; _index < users.length; _index++) {
            if(users[_index] == _userAddress) {
                users[_index] = users[users.length - 1];
                users.pop();
            }
        }
        total -= userToPercent[_userAddress];
        userToPercent[_userAddress] = 0;
    }
    
}