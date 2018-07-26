pragma solidity ^0.4.0;

//link http://solidity.readthedocs.io/en/develop/contracts.html#visibility-and-getters
contract ExternalContract {
    //for calling externalCall use this.externalCall()
    //input is passed to stack
    function externalCall(string x) external returns (uint) {
        return 123;
    }
    
    //for calling publicCall use publicCall()
    //input is passed to memory
    function publicCall(string x) public returns (uint) {
        return 123;     
    }
}
