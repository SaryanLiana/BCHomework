// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

/**
* @title MaxArray 
*/
contract MaxArray{

    uint[] public _maxArr;

    /**
    * @dev Return array of max numbers.
    * @param _arr array of numbers.
    * @param _num number of max numbers in the array.
    */
    function maxNumbersOfArray(uint[] memory _arr, uint _num) public {

        require(_arr.length > _num, "Size error");

        for(uint i = 0; i < _arr.length - 2; i++){
            for(uint j = i + 1; j < _arr.length - 1; j++){
                if(_arr[i] > _arr[j]){
                    (_arr[i], _arr[j]) = (_arr[j], _arr[i]);
                }
            }
        }

        for(uint i = 1; i <=  _num; i++){
            _maxArr.push(_arr[_arr.length - i]);
        }
    }
}