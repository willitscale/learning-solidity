pragma solidity ^0.5.0;

contract ExternalContract {
    function externalCall(string calldata x) external returns (uint) {
        return 123;
    }
    
    function publicCall(string memory x) public returns (uint) {
        return 123;
    }
}
