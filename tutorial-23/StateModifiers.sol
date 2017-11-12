pragma solidity ^0.4.0;

contract StateModifiers {
    uint private constant varConstantValue = 55;
    uint private stateValue;
    
    function stateAccess() public returns (uint) {
        stateValue = 10;
        return stateValue;
    }
    
    function constantAccess() public constant returns (uint) {
        return block.number;
    }
    
    function viewAccess() public view returns (uint) {
        return stateValue;
    }
    
    function pureAccess() public pure returns (uint) {
        return varConstantValue;
    }
}