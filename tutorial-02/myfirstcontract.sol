pragma solidity ^0.7.0;

interface Regulator{
    function checkValue(uint amount) external returns (bool);
    function loan() external returns (bool);
}

contract Bank is Regulator {
    uint private value;

    constructor(uint amount) {
        value = amount;
    }
    function deposit(uint amount) public {
        value += amount;
    }
    function withdraw(uint amount) public {
        if (checkValue(amount)) {
        value -= amount;
        }
    }
    function balance() public view returns (uint) {
        return value;
    }
    function checkValue(uint amount) override view public returns (bool) {
        // Classic mistake in the tutorial value should be above the amount
        return value >= amount;
    }
    function loan() override view public returns (bool) {
        return value > 0;
    }
}

// Tutorial 01
contract myFirstContract is Bank(10) {

    string private name;
    uint private age;

    function setName(string memory newName) public {
        name = newName;
    }
    function setAge(uint newAge) public {
        age = newAge;
    }
    function getName() public view returns (string memory) {
        return name;
    }
    function getAge() public view returns (uint) {
        return age;
    }
}
