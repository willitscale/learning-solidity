pragma solidity ^0.4.0;

import "./Token.sol";
import "./ERC20.sol";
import "./ERC223.sol";
import "./ERC223ReceivingContract.sol";
import "./SafeMath.sol";
import "./Addresses.sol";

contract MyToken is Token("MFT", "My Token", 0, 10000), ERC20, ERC223 {

    using SafeMath for uint;
    using Addresses for address;

    function MyToken()
        public {
        _balanceOf[msg.sender] = _totalSupply;
    }

    function totalSupply()
        public
        view
        returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr)
        public
        view
        returns (uint) {
        return _balanceOf[_addr];
    }

    function transfer(address _to, uint _value)
        public
        returns (bool) {
        return transfer(_to, _value, "");
    }

    function transfer(address _to, uint _value, bytes _data)
        public
        returns (bool) {
        if (_value > 0 &&
            _value <= _balanceOf[msg.sender]) {

            if (_to.isContract()) {
              ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
              _contract.tokenFallback(msg.sender, _value, _data);
            }

            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);

            return true;
        }
        return false;
    }

    function transferFrom(address _from, address _to, uint _value)
        public
        returns (bool) {
        return transferFrom(_from, _to, _value, "");
    }

    function transferFrom(address _from, address _to, uint _value, bytes _data)
        public
        returns (bool) {
        if (_allowances[_from][msg.sender] > 0 &&
            _value > 0 &&
            _allowances[_from][msg.sender] >= _value &&
            _balanceOf[_from] >= _value) {

              _allowances[_from][msg.sender] -= _value;

              if (_to.isContract()) {
                ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
                _contract.tokenFallback(msg.sender, _value, _data);
              }

            _balanceOf[_from] = _balanceOf[_from].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);

            Transfer(_from, _to, _value);

            return true;
        }
        return false;
    }

    function approve(address _spender, uint _value)
        public
        returns (bool) {
        if (_balanceOf[msg.sender] >= _value) {
          _allowances[msg.sender][_spender] = _value;
          Approval(msg.sender, _spender, _value);
          return true;
        }
        return false;
    }

    function allowance(address _owner, address _spender)
        public
        view
        returns (uint) {
        if (_allowances[_owner][_spender] < _balanceOf[_owner]) {
          return _allowances[_owner][_spender];
        }
        return _balanceOf[_owner];
    }
}
