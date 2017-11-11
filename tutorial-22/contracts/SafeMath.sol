pragma solidity ^0.4.0;

library SafeMath {
  function sub(uint _base, uint _value)
    internal
    pure
    returns (uint) {
    assert(_value <= _base);
    return _base - _value;
  }

  function add(uint _base, uint _value)
    internal
    pure
    returns (uint _ret) {
    _ret = _base + _value;
    assert(_ret >= _base);
  }

  function div(uint _base, uint _value)
    internal
    pure
    returns (uint) {
    assert(_value > 0 && (_base % _value) == 0);
    return _base / _value;
  }

  function mul(uint _base, uint _value)
    internal
    pure
    returns (uint _ret) {
    _ret = _base * _value;
    assert(0 == _base || _ret / _base == _value);
  }
}
