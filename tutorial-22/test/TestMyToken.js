var MyToken = artifacts.require("./MyToken.sol");

contract('MyToken', (accounts) => {

  var creatorAddress = accounts[0];
  var recipientAddress = accounts[1];
  var delegatedAddress = accounts[2];

  it("should contain 10000 MyToken in circulation", () => {
    return MyToken.deployed().then((instance) => {
      return instance.totalSupply.call();
    }).then(balance => {
      assert.equal(balance.valueOf(), 10000, "10000 MyToken are not in circulation");
    });
  });

  it("should contain 10000 MyToken in the creator balance", () => {
    return MyToken.deployed().then(instance => {
      return instance.balanceOf.call(creatorAddress);
    }).then(balance => {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the creator balance");
    });
  });

  it("should transfer 1000 MyToken to the recipient balance", () => {
    var myTokenInstance;
    return MyToken.deployed().then(instance => {
      myTokenInstance = instance;
      return myTokenInstance.transfer(recipientAddress, 1000, {from: creatorAddress});
    }).then(result => {
      return myTokenInstance.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1000, "1000 wasn't in the recipient balance");
      return myTokenInstance.balanceOf.call(creatorAddress);
    }).then(creatorBalance => {
      assert.equal(creatorBalance.valueOf(), 9000, "9000 wasn't in the creator balance");
    });
  });

  it("should approve 500 MyToken to the delegated balance", () => {
    var myTokenInstance;
    return MyToken.deployed().then(instance => {
      myTokenInstance = instance;
      return myTokenInstance.approve(delegatedAddress, 500, {from: creatorAddress});
    }).then(result => {
      return myTokenInstance.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 500, "500 wasn't approved to the delegated balance");
    });
  });

  it("should transfer 200 MyToken from the creator to the alt recipient via the delegated address", () => {
    var myTokenInstance;
    return MyToken.deployed().then(instance => {
      myTokenInstance = instance;
      return myTokenInstance.transferFrom(creatorAddress, recipientAddress, 200, {from: delegatedAddress});
    }).then(result => {
      return myTokenInstance.balanceOf.call(recipientAddress);
    }).then(recipientBalance => {
      assert.equal(recipientBalance.valueOf(), 1200, "1200 wasn't in the recipient balance");
      return myTokenInstance.allowance.call(creatorAddress, delegatedAddress);
    }).then(delegatedAllowance => {
      assert.equal(delegatedAllowance.valueOf(), 300, "300 wasn't set as the delegated balance");
    });
  });

});
