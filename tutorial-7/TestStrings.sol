pragma solidity ^0.4.0;

import "browser/Strings.sol";

contract TestStrings {
    
    using Strings for string;
    
    function testConcat(string _base) returns (string) {
        return _base.concat("_suffix");
    }
    
    function needleInHaystack(string _base) returns (int) {
        return _base.strpos("t");
    }
}
