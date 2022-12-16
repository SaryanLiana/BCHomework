// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
* @title IntegralAndDerivative
* @dev this contract calculates the integral and derivative for the given function
*/
contract IntegralAndDerivative {

    using Strings for uint256;

    uint256 result;
    uint256 quotient;
    uint256 remainder;
    uint256[] coefficients;

    /**
    * @dev The function that user entered.
    * Note: the function will be 2 + 2x^2 + 3x^4 if we entered [2, 0, 3, 0, 3] array.
    * @param _number the coefficient of the function .
    */
    function aFunction(uint256 _number) public {
        coefficients.push(_number);
    }

    /**
    * @dev Gets the remainder and the quotient and connect them with ".".
    * @param _lowerBound the lower bound of the integral.
    * @param _upperBound the upper bound of the integral.
    * @return string the answer of the integral.
    */
    function calculateIntegral1(uint256 _lowerBound, uint256 _upperBound) public returns(string memory) {
        if(_lowerBound <= _upperBound) {
            result = calculateIntegralAtThePoint(_upperBound) - calculateIntegralAtThePoint(_lowerBound);
            quotient = result / 100000;               //because result is bigger from expected result 100000 times
            remainder = result % 100000;
            return string(abi.encodePacked(quotient.toString(), ".", remainder.toString()));
        }
        else {
            result = calculateIntegralAtThePoint(_lowerBound) - calculateIntegralAtThePoint(_upperBound);
            quotient = result / 100000;
            remainder = result % 100000;
            return string(abi.encodePacked("-", quotient.toString(), ".", remainder.toString()));
        }
    }

    /**
    * @dev Calculate the derivative at a user-entered point.
    * @param _value the point where we need to calculate the derivative.
    * @return sum the derivative at the point _value.
    */
    function calculateDerivativeAtThePoint(uint256 _value) public view returns(uint256 sum) {
        for(uint256 _index = 1; _index < coefficients.length; _index++) {
            sum += coefficients[_index] * _index * (_value ** (_index - 1));
        }
    }

    /**
    * @dev Since there are no floating point numbers, we must multiply it by a large number,
    * then divide the result by that number.
    * @param _value the point where we need to calculate the integral.
    * @return sum the value of the integral at the point _value times 100000.
    */
    function calculateIntegralAtThePoint(uint256 _value) private view returns(uint256 sum) {
        for(uint256 _index; _index < coefficients.length; _index++) {
            sum += ((coefficients[_index] * 100000) * (_value ** (_index + 1))) / (_index + 1);
        }
    }
}