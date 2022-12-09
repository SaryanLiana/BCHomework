// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

interface IBusd {
    function getOwner() external view returns (address);
    function totalSupply() external view  returns (uint256);
    function balanceOf(address _addr) external view returns (uint256);   
    function allowance(address _owner, address _spender) external view returns (uint256);
}

contract DelCall {
    
    address public busd = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee;

    /*
    * @dev Gets the balance of the specified address.
    * @return An uint256 representing the amount of msg.sender.
    */
    function callBalanceOf() external view returns (uint256) {
        return IBusd(busd).balanceOf(msg.sender);
    }

    /*
    * @dev Returns the address of the current owner.
    */
    function callGetOwner() external view returns (address) {
        return IBusd(busd).getOwner();
    }

    /*
    * @dev Total number of tokens in existence.
    */
    function callTotalSupply() external view returns (uint256) {
        return IBusd(busd).totalSupply();
    }

    /*
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */     
    function callAllowance(address _owner, address _spender) external view returns (uint256) {
        return IBusd(busd).allowance(_owner, _spender);
    }
}