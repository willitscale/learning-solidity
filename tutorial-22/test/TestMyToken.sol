pragma solidity ^0.4.0;

import "truffle/Assert.sol";
import "../contracts/MyToken.sol";

contract TestMyToken {

  MyToken private _myToken;
  address private _owner;

  function TestMyToken() public {
    _owner = msg.sender;
  }

  function beforeEach() public {
    _myToken = new MyToken();
  }

  function test_constructor() public {
    uint allocatedTokens = _myToken.balanceOf(this);
    Assert.equal(allocatedTokens, 10000, "Contract creator should hold 10000 tokens");
  }

  function test_transfer_withValidAmount() public {
    _myToken.transfer(_owner, 100);
    uint transferredTokens = _myToken.balanceOf(_owner);
    uint allocatedTokens = _myToken.balanceOf(this);
    Assert.equal(transferredTokens, 100, "Recipient should hold 100 tokens");
    Assert.equal(allocatedTokens, 9900, "Contract creator should hold 9900 tokens");
  }

  function test_transfer_withInvalidAmount() public {
    bool transferSuccessful = _myToken.transfer(_owner, 10001);
    Assert.equal(transferSuccessful, false, "Addresses should not be able to transfer more tokens than allocated");
  }

  function test_totalSupply() public {
    uint totalSupply = _myToken.totalSupply();
    Assert.equal(totalSupply, 10000, "There should be 10000 tokens in circulation");
  }

  function test_transferFrom_withInvalidAllocation() public {
    _myToken.transfer(_owner, 100);
    bool transferSuccessful = _myToken.transferFrom(_owner, this, 100);
    Assert.equal(transferSuccessful, false, "Unauthorised addresses should not be able to transfer tokens");
  }

  function test_approve_withValidAmount() public {
    bool allocationSuccessful = _myToken.approve(_owner, 100);
    Assert.equal(allocationSuccessful, true, "Token owner should be able to allocate less than or equal to their holdings");
  }

  function test_approve_withInvalidAmount() public {
    bool allocationSuccessful = _myToken.approve(_owner, 10001);
    Assert.equal(allocationSuccessful, false, "Token owner should not be able to allocate more than their holdings");
  }

  function test_allowance_withNoAllocatedBalance() public {
    uint allowanceAvailable = _myToken.allowance(_owner, this);
    Assert.equal(allowanceAvailable, 0, "Spender should not have a balance available");
  }

  function test_allowance_withAllocatedBalance() public {
    _myToken.approve(_owner, 100);
    uint allowanceAvailable = _myToken.allowance(_owner, this);
    Assert.equal(allowanceAvailable, 0, "Spender should have a balance of 100 available");
  }
}
