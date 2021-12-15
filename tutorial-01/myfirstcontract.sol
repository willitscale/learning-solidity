// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract myfirstcontract {

    string private name;
    uint private age;


    function setName(string memory newName) public {
        
        name = newName;

    }

    function getName() public view returns (string memory) {
        return name;
        

    }


}
