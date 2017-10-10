pragma solidity ^0.4.0;

contract Random {

    function unsafeBlockRandom() 
        public
        returns (uint) {
        return uint(block.blockhash(block.number-1)) % 100;
    }
    
    uint private _baseIncrement;
    
    function unsafeIncrementRandom() 
        public
        returns (uint) {
        return uint(sha3(_baseIncrement++)) % 100;
    }

}