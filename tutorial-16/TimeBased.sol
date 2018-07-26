pragma solidity ^0.4.0;

contract TimeBased {
    
    mapping(address => uint) public _balanceOf;
    mapping(address => uint) public _expiryOf;
    
    uint private leaseTime = 600;
    
    modifier expire(address _addr) {
        if (_expiryOf[_addr] <= block.timestamp) {
            _expiryOf[_addr] = 0;
            _balanceOf[_addr] = 0;
        }
        _;
    }
    
    function lease()
        public
        payable
        expire(msg.sender)
        returns (bool) {
        require(msg.value == 1 ether);
        require(_balanceOf[msg.sender] == 0);
        _balanceOf[msg.sender] = 1;
        _expiryOf[msg.sender] = block.timestamp + leaseTime;
        return true;
    }
    
    function balanceOf() 
        public
        returns (uint) {
        return balanceOf(msg.sender);        
    }
    
    function balanceOf(address _addr)
        public
        expire(_addr)
        returns (uint) {
        return _balanceOf[_addr];
    }
    
    function expiryOf() 
        public
        returns (uint) {
        return expiryOf(msg.sender);        
    }
    
    function expiryOf(address _addr)
        public
        expire(_addr)
        returns (uint) {
        return _expiryOf[_addr];
    }
}
