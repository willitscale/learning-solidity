pragma solidity ^0.4.0;

import "./ERC223ReceivingContract.sol";
import "./SafeMath.sol";
import "./ERC20.sol";
import "./Token.sol";

contract Crowdsale is ERC223ReceivingContract {

  using SafeMath for uint;

  Token private _token;

  uint private _start;
  uint private _end;

  uint private _price;
  uint private _limit;
  uint private _available;

  mapping (address => uint) private _limits;

  event Buy(address beneficiary, uint amount);

  modifier available() {
    require(_available > 0);
    require(block.number >= _start && block.number < _end);
    _;
  }

  modifier isToken() {
    require(msg.sender == address(_token));
    _;
  }

  modifier valid(address to, uint amount) {
    assert(amount > 0);
    amount = amount.div(_price);
    assert(_limit >= amount);
    assert(_limit >= _limits[to].add(amount));
    _;
  }

  function Crowdsale(address token, uint start, uint end, uint price, uint limit)
      public {
      _token = Token(token);
      _start = start;
      _end = end;
      _price = price;
      _limit = limit;
  }

  function ()
      public
      payable {
      // Not enough gas for the transaction so prevent users from sending ether
      revert();
  }

  function buy()
      public
      payable {
      return buyFor(msg.sender);
  }

  function buyFor(address beneficiary)
      public
      available
      valid(beneficiary, msg.value)
      payable {
      uint amount = msg.value.div(_price);
      _token.transfer(beneficiary, amount);
      _available = _available.sub(amount);
      _limits[beneficiary] = _limits[beneficiary].add(amount);
      Buy(beneficiary, amount);
  }

  function tokenFallback(address, uint _value, bytes)
      isToken
      public {
      _available = _available.add(_value);
  }

  function availableBalance()
    view
    public
    returns (uint) {
    return _available;
  }
}
