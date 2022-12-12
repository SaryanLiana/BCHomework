// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

/**
* @title Shareholders
* @dev this contract adds and removes users by the owner and sends users
* ether according to their percentage for not keeping ether in the contract 
*/
contract Shareholders {

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
    uint256 public total = 0;

    /**
    * The constructor initializes the owner.
    */
    constructor() {
        owner = msg.sender;
    }

    /**
    * @dev sends ethers to users corresponding to their percentage.
    */
    receive() external payable {
        for(uint256 _index = 0; _index < users.length - 1; _index++) {
            users[_index].transfer((address(this).balance * userToPercent[users[_index]]) / 100);
        }
    }

    /**
    * @dev adds users.
    * Note: the use of onlyOwner ensures that this function can call only owner.
    * @param _userAddress the address of the user that should be added.
    * @param _percentage the percentage that the user should receive from the amount.
    */
    function addUsers(address payable _userAddress, uint256 _percentage) payable public onlyOwner {
        if(userToPercent[_userAddress] == 0 && total + _percentage < 100) {
            users.push(_userAddress);
            total += _percentage;
        } 

        for(uint256 i; i < users.length - 1; i++) {
            if(userToPercent[_userAddress] != 0 && users[i] == _userAddress && total + _percentage - userToPercent[_userAddress] < 100) {
                total -= userToPercent[_userAddress];
                total += _percentage;
            }
        }
        userToPercent[_userAddress] = _percentage; 
    }

    /**
    * @dev removes users.
    * Note: the use of onlyOwner ensures that this function can call only owner.
    * @param _userAddress the address of the user that should be removed.
    */
    function removeUsers(address _userAddress) public onlyOwner {
        for(uint256 _index = 0; _index < users.length - 1; _index++) {
            if(users[_index] == _userAddress) {
                users[_index] = users[users.length - 1];
                users.pop();
            }
        }
        total -= userToPercent[_userAddress];
        userToPercent[_userAddress] = 0;
    }
    
}