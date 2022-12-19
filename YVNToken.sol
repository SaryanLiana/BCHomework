// SPDX-License-Identifier: MIT

pragma solidity  ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YVNToken is IERC20, Ownable {
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public totalSupply;
    string public name;
    uint8 public decimals;
    string public symbol;

    /**
    * @dev Sets the values for name, symbol, decimals and totalSupply.
    */
    constructor(uint256 _initialAmount) {
        balanceOf[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = "YVN";
        decimals = 18;
        symbol = "yvn";
    }

    /**
    * @dev send _amount token to _recipient from msg.sender.
    * @param _recipient The address of the recipient.
    * @param _amount The amount of token to be transferred.
    * @return success Whether the transfer was successful or not.
    */
    function transfer(address _recipient, uint256 _amount) public returns (bool success) {
        require(balanceOf[msg.sender] >= _amount, "YVNToken: Your balance is lower than the value requested");
        balanceOf[msg.sender] -= _amount;
        balanceOf[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount); 
        return true;
    }

    /**
    * @dev send _amount of token to _recipient from _spender.
    * @param _spender The address of the spender.
    * @param _recipient The address of the recipient.
    * @param _amount The amount of token to be transferred.
    * @return success Whether the transfer was successful or not.
    */
    function transferFrom(address _spender, address _recipient, uint256 _amount) public returns (bool success) {
        uint256 _allowance = allowed[_spender][msg.sender];
        require(balanceOf[_spender] >= _amount && _allowance >= _amount, "YVNToken: balance of allower or _allowance is lower than requested amount");
        balanceOf[_recipient] += _amount;
        balanceOf[_spender] -= _amount;
        if (_allowance < MAX_UINT256) {
            allowed[_spender][msg.sender] -= _amount;
        }
        emit Transfer(_spender, _recipient, _amount); 
        return true;
    }

    /**
    * @dev msg.sender approves _spender to spend _amount of tokens.
    * @param _spender The address of the account able to transfer the tokens.
    * @param _amount The amount of wei to be approved for transfer.
    * @return success Whether the approval was successful or not.
    */
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount); 
        return true;
    }

    /**
    * @dev _owner gives allowance to the _spender.
    * @param _owner The address of the account owning tokens.
    * @param _spender The address of the account able to transfer the tokens.
    * @return remaining Amount of remaining tokens allowed to spent.
    */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /**
    * @dev mint _amount of tokens.
    * @param _amount tokens that must be minted.
    */
    function mint(uint256 _amount) public onlyOwner {
        require(_amount > 0, "YVNToken: Minted tokens must be greater than 0.");
        totalSupply += _amount;
        balanceOf[msg.sender] += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    /**
    * @dev burn _amount of tokens.
    * @param _amount tokens that must be burned.
    */
    function burn(uint256 _amount) public onlyOwner {
        require(totalSupply >= _amount, "YVNToken: _amount exceeds Total supply.");
        totalSupply -= _amount;
        balanceOf[msg.sender] -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }
}