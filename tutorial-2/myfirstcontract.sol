pragma solidity ^0.4.0;

interface Regulator {
    function checkValue(uint amount) returns (bool);
    function loan() returns (bool);
}

contract Bank is Regulator {
    uint private value;
    
    function Bank(uint amount) {
        value = amount;
    }
    
    function deposit(uint amount) {
        value += amount;
    }
    
    function withdraw(uint amount) {
        if (checkValue(amount)) {
            value -= amount;
        }
    }
    
    function balance() returns (uint) {
        return value;
    }
    
    function checkValue(uint amount) returns (bool) {
        // Classic mistake in the tutorial value should be above the amount
        return value >= amount;
    }
    
    function loan() returns (bool) {
        return value > 0;
    }
}

contract MyFirstContract is Bank(10) {
    string private name;
    uint private age;
    
    function setName(string newName) {
        name = newName;
    }
    
    function getName() returns (string) {
        return name;
    }
    
    function setAge(uint newAge) {
        age = newAge;
    }
    
    function getAge() returns (uint) {
        return age;
    }
}
