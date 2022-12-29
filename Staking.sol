// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

interface IYVNToken {
    function transfer(address _recipient, uint256 _amount) external returns (bool success);
}

contract Staking {

    struct User {
        uint256 depositAmount;
        uint256 rewardDebt;
    }

    mapping(address => User) public addressToUserInfo;
    uint256 public totalAmount;
    uint256 public mintCount;
    address public rewardToken;
    uint256 startAt;
    address[] addresses;

    /**
    * @dev Sets the values for mintCount, rewardToken.
    */
    constructor(uint256 _mintCountForSecond, address _rewardToken) {
        mintCount = _mintCountForSecond;
        rewardToken = _rewardToken;
    }

    /**
    * @dev user deposit their ether.
    */
    function deposit() external payable {
        require(msg.value > 0, "Staking: Your deposit amount should be greater than 0!");
        update();
        if(addressToUserInfo[msg.sender].depositAmount == 0) {
            addresses.push(msg.sender);
        }
        totalAmount += msg.value;
        addressToUserInfo[msg.sender].depositAmount += msg.value;
    }

    /**
    * @dev user withdraw their ether and claim reward.
    */
    function withdraw() external {
        require(addressToUserInfo[msg.sender].depositAmount != 0, "Staking: You didn't deposit anything!");
        update();
        uint256 userReward = addressToUserInfo[msg.sender].rewardDebt;
        uint256 userDeposit = addressToUserInfo[msg.sender].depositAmount;
        for(uint256 i; i < addresses.length; ++i) {
            if(addresses[i] == msg.sender) {
                addresses[i] = addresses[addresses.length - 1];
                addresses.pop();
            } 
        }
        delete(addressToUserInfo[msg.sender]);
        totalAmount -= userDeposit;
        payable(msg.sender).transfer(userDeposit);
        IYVNToken(rewardToken).transfer(msg.sender, userReward);
    }

    /**
    * @dev user claim reward.
    */
    function claimReward() external {
        require(addressToUserInfo[msg.sender].depositAmount != 0, "Staking: You didn't deposit anything!");
        update();
        uint256 temp = addressToUserInfo[msg.sender].rewardDebt;
        addressToUserInfo[msg.sender].rewardDebt = 0;
        IYVNToken(rewardToken).transfer(msg.sender, temp);
    } 

    /**
    * @dev calculate amount of tokens that user should be claim.
    */
    function update() private {
        uint256 mintedAmount = (block.timestamp - startAt) * mintCount;
        for(uint256 i; i < addresses.length; ++i) {
            addressToUserInfo[addresses[i]].rewardDebt += mintedAmount * addressToUserInfo[addresses[i]].depositAmount / totalAmount;
        }
        startAt = block.timestamp;
    }
}