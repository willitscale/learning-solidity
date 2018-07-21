pragma solidity ^0.4.0;

contract Transaction {
    
    event SenderLogger(address);
    event ValueLogger(uint);
    
    address private owner;
    
    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    modifier validValue {
        assert(msg.value >= 1 ether);
        _;
    }
    
    //deprecated. use constructor (){} instead
        function Transaction() {
        owner = msg.sender;
    }
    
    function () payable isOwner validValue {
        SenderLogger(msg.sender);
        ValueLogger(msg.value);
        // use event with emit
        emit ValueLogger(block.number);
        // http://solidity.readthedocs.io/en/develop/units-and-global-variables.html#block-and-transaction-properties
        // other loggig numbers
    }
    
}
