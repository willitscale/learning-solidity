pragma solidity ^0.4.0;

contract ExternalContract {
    function externalCall(string x) external returns (uint) {
        return 123;
    }
    
    function publicCall(string x) public returns (uint) {
        return 123;
    }
}