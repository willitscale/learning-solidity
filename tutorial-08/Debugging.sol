pragma solidity ^0.4.0;

contract Debugging {
    
    uint[] private vars;
    
    function assignment() public pure {
        uint myVal1 = 1;
        uint myVal2 = 2;
        assert(myVal1 == myVal2);
    }
    
    function memoryAlloc() public pure {
        string memory myString = "test";
        assert(bytes(myString).length == 10);
    }
    
    function storageAlloc() public {
        vars.push(2);
        vars.push(3);
        assert(vars.length == 4);
    }
    
}
