pragma solidity ^0.4.0;

contract AddressBook {
    mapping(address => address[]) private _addresses;
    mapping(address => mapping(address => string)) private _aliases;

    function getAddresses() public view returns (address[]) {
        return _addresses[msg.sender];
    }

    function addAddress(address addr, string alias) public {
        _addresses[msg.sender].push(addr);
        _aliases[msg.sender][addr] = alias;
    }

    function removeAddress(address addr) public {
        uint length = _addresses[msg.sender].length;
        for(uint i = 0; i < length; i++) {
            if (addr == _addresses[msg.sender][i]) {
                if (1 < _addresses[msg.sender].length && i < length-1) {
                    _addresses[msg.sender][i] = _addresses[msg.sender][length-1];
                }
                delete _addresses[msg.sender][length-1];
                _addresses[msg.sender].length--;
                delete _aliases[msg.sender][addr];
                break;
            }
        }
    }

    function getAlias(address addr) public view returns (string) {
        return _aliases[msg.sender][addr];
    }
}
