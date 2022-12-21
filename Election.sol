// SPDX-License-Identifier: MIT

pragma solidity  ^0.8;

interface IShareholders {
    function addUsers(address payable _userAddress, uint256 _percentage) external;
}

contract Election{

    event Voted(uint256 _totalVotes);

    mapping(address => bool) public candidates;
    mapping(address => uint256) public results;
    mapping(address => uint256) public candidateVotes;
    mapping(address => bool) isVoted;

    uint256 public immutable startAt;
    uint256 public immutable endAt;
    uint256 public investment;
    uint256 public totalVotes;
    address shareholderContractAddress;
    address payable[] candidatesAddresses;

    constructor(uint256 _investment) {
        investment = _investment * 10 ** 18;
        startAt = block.timestamp;
        endAt = block.timestamp + 3 minutes;
    }

    receive() external payable {}

    /**
    * @dev msg.sender become a candidate by sending a certain amount of ether.
    */
    function becomeCandidate() external payable {
        require(msg.value == investment,"Election: Not enough money to become a candidate");
        require(candidates[msg.sender] == false, "Election: You already are a candidate.");
        candidates[msg.sender] = true;
        candidatesAddresses.push(payable(msg.sender));
    }

    /**
    * @dev voter votes to _candidate and increases the count of candidate votes, total votes.
    * @param _candidate the address of the candidate that should be voted by voter.
    */
    function vote(address _candidate) external {
        require(candidates[_candidate] == true, "Election: No such candidate.");
        require(block.timestamp < endAt, "Election: Elections are over.");
        require(isVoted[msg.sender] == false, "Election: You have already voted.");
        isVoted[msg.sender] = true;
        candidateVotes[_candidate]++;
        totalVotes++;
        emit Voted(totalVotes);
    }

    /**
    * @dev calculate the percentage of candidate of total votes.
    */
    function candidatesCollectedVotesInPercentage() external {
        require(block.timestamp > endAt, "Election: The election is not over yet.");
        for(uint256 _index; _index < candidatesAddresses.length; _index++) {
            results[candidatesAddresses[_index]] = (candidateVotes[candidatesAddresses[_index]] * 100) / totalVotes;
        }
    } 

    /**
    * @dev gives money to cadidates according to their collected votes.
    * @param _shareholderContractAddress address of Shareholder contract.
    */
    function UpdateTime(address _shareholderContractAddress) external {
        shareholderContractAddress = _shareholderContractAddress;
        if(block.timestamp > endAt) {
            callAddUsers();
        }
    }

    /**
    * @dev call addUssers from Shareholder contract.
    */
    function callAddUsers() private {
        require(block.timestamp > endAt, "Election: The election is not over yet.");
        for(uint256 _index; _index < candidatesAddresses.length; _index++) {
            address payable _candidateAddress = candidatesAddresses[_index];
            uint256 _percentage = results[_candidateAddress];
            IShareholders(shareholderContractAddress).addUsers(_candidateAddress, _percentage);
        }
        (bool success,) = shareholderContractAddress.call{ value: address(this).balance }("");
        require(success, "Election: Faild!");
    }
}