// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface Regulator {
    function checkValue(uint amount) external returns (bool);
    function loan() external returns (bool);
}

contract Bank is Regulator{

    uint private value;

    constructor(uint amount) {

        value = amount;
    }

    function deposit(uint amount) public {
        value += amount;
    }

    function withdrawel(uint amount) public {

        if (checkValue(amount)){
            value -= amount;

        }
    }

    function balance() public view returns (uint) {

        return value;
    }

    // Override

    function checkValue(uint amount) public override view returns (bool) {

        return value > amount;

    }

    function loan() public override view returns (bool) {

        return value > 0;

    }

}

contract myfirstcontract is Bank(10) {

    // Opposite of Java - private String firstName;
    string private name;
    uint private age;


    function setName(string memory newName) public {
        
        name = newName;

    }

    function getName() public view returns (string memory) {
        return name;

    }

    function setAge(uint newAge) public {
        age = newAge;
    }

    function getAge() public view returns (uint) {
        return age;

    }

    

}
