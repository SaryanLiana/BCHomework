// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

/**
* @title Shop
* @dev this contract is the database for the shop. 
*/
contract Shop {
    
    address shop = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372;
   
    /**
    * @dev Throws if called by any account other than shop.
    */
    modifier onlyShop() {
        require(shop == shop, "not shop");
        _;
    }

    mapping(address => mapping(string => bool)) private userToPurchaseList;
    
    /**
    * @dev Return true if user bought the product.
    * @param _str product name.
    */
    function isBought(string memory _str) external view returns(bool){
        return userToPurchaseList[msg.sender][_str];
    }

    /**
    * @dev Keeps the list of the products that user bought.
    * Note: the use of onlyShop ensures that this function can call only shop.
    * @param _user the address of the user.
    * @param _str the product name that user bought.
    */
    function listOfProduct(address _user, string memory _str) external onlyShop {
        userToPurchaseList[_user][_str] = true;
    }
}