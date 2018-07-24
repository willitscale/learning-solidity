pragma solidity ^0.4.0;
// topic on memory,storage and stack differeces
// https://ethereum.stackexchange.com/questions/23720/usage-of-memory-storage-and-stack-areas-in-evm/23722#comment24703_23722
contract Debugging {
    
    uint[] private vars;
    
    function assignment() {
        //stack Debugging
        uint myVal1 = 1;
        uint myVal2 = 2;
        assert(myVal1 == myVal2);
    }
    
    function memoryAlloc() {
        //memory Debugging
        string memory myString = "test";
        assert(bytes(myString).length == 10);
    }
    
    function storageAlloc() {
        //storage Debugging
        vars.push(2);
        vars.push(3);
        assert(vars.length == 4);
    }
    
}
