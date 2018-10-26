pragma solidity ^0.4.0;

import "browser/Strings.sol";

contract TestStrings {
    
    using Strings for string;
    
    function testConcat(string _base) public pure returns (string) {
        return _base.concat("_suffix");
    }
    
    function needleInHaystack(string _base) public pure returns (int) {
        return _base.strpos("t");
    }
}
