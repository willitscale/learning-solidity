//SPDX-License-Identifier: Unlicense
// Providing the Licence type to the compiler which is added to the top as a comment

//Specifing the version of compiler used to compile the contract
pragma solidity ^0.8.0;

//contract is the keyword like class to create a new Contract
contract MyFirstContract {
    
    //Visibility is set to private so that variables are only accessible inside the contract
    string private name;
    uint private age;
    
    /**
    @dev To set the name to the name provided by the user
    @param newName To get the name from the user to store it in the Blockchain
    memory is a keyword used to temporarily store data in the Blockchain 
    */
    function setName(string memory newName) public {
        name = newName;
    }
    
    /**
    @dev To get the value of name from the Blockchain as the variable are set private
    memory is a keyword used to temporarily store data in the Blockchain 
    */
    function getName() public view returns (string memory) {
        return name;
    }
    
    /**
    @dev To set the age to the name provided by the user
    @param newName To get the age from the user to store it in the Blockchain
    */
    function setAge(uint newAge) public {
        age = newAge;
    }
    
    /**
    @dev To get the value of age from the Blockchain as the variable are set private
    */
    function getAge() public view returns (uint) {
        return age;
    }
}
