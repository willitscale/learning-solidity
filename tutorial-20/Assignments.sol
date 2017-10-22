pragma solidity ^0.4.0;

contract Assignments {
    function returnFirstValue(uint a, uint b) returns (uint) {
        return a;
    }
    
    function caller() public returns (uint) {
        return returnFirstValue({b:4, a:8});
    }
    
    function returnAllValues(uint a, uint b, uint c) returns (uint, uint, uint) {
        return (a,b,c);
    }
    
    function callerAll() public returns (uint, uint, uint) {
        var(x,y,z) = returnAllValues(4,5,6);
        (x,y) = (y,x);
        (x,) = returnAllValues(5,10,15);
        (,z) = returnAllValues(10,20,30);
        return (x,y,z);
    }
}