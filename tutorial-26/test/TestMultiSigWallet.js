var MultiSigWallet = artifacts.require("./MultiSigWallet.sol");

contract('MultiSigWallet', (accounts) => {
  var creatorAddress = accounts[0];
  var firstOwnerAddress = accounts[1];
  var secondOwnerAddress = accounts[2];
  var externalAddress = accounts[3];

  it('should revert the transaction of addOwner when an invalid address calls it', () => {
    return MultiSigWallet.deployed()
      .then(instance => {
        return instance.addOwner(firstOwnerAddress, {from:externalAddress});
      })
      .then(result => {
        assert.fail();
      })
      .catch(error => {
        assert.notEqual(error.message, "assert.fail()", "Transaction was not reverted with an invalid address");
      });
  });

  it('should revert the transaction of removeOwner when an invalid address calls it', () => {
    return MultiSigWallet.deployed()
      .then(instance => {
        return instance.removeOwner(firstOwnerAddress, {from:externalAddress});
      })
      .then(result => {
        assert.fail();
      })
      .catch(error => {
        assert.notEqual(error.message, "assert.fail()", "Transaction was not reverted with an invalid address");
      });
  });

  it('should not revert the transaction of owner modification by the creator address', () => {
    var multiSigWalletInstance;
    return MultiSigWallet.deployed()
      .then(instance => {
        multiSigWalletInstance = instance;
        return multiSigWalletInstance.removeOwner(creatorAddress);
      })
      .then(removedResult => {
        return multiSigWalletInstance.addOwner(creatorAddress);
      })
      .catch(error => {
        assert.fail("Transaction was reverted by a creator call");
      });
  });

  it('should revert the transaction of deleteTransaction on an invalid transaction ID', () => {
    return MultiSigWallet.deployed()
      .then(instance => {
        return instance.deleteTransaction(1);
      })
      .then(result => {
        assert.fail();
      })
      .catch(error => {
        assert.notEqual(error.message, "assert.fail()", "Transaction was not reverted with an invalid transaction ID passed");
      })
  });

  it('should revert the transaction if the creator of a pending transaction tries to sign the transaction', () => {
    var multiSigWalletInstance;
    return MultiSigWallet.deployed()
       .then(instance => {
           multiSigWalletInstance = instance;
           return multiSigWalletInstance.sendTransaction({from: creatorAddress, value: 1000})
         })
        .then(sendResult => {
          return multiSigWalletInstance.withdraw(100);
        })
        .then(withdrawResult => {
          return multiSigWalletInstance.signTransaction(0);
        })
        .then(signResult => {
          assert.fail();
        })
        .catch(error => {
          assert.notEqual(error.message, "assert.fail()", "Transaction was not reverted after creator signed a transaction");
        });
  });

  it('should revert the transaction if the signer of a pending transaction tries to sign the transaction again', () => {
    var multiSigWalletInstance;
    return MultiSigWallet.deployed()
       .then(instance => {
           multiSigWalletInstance = instance;
           return multiSigWalletInstance.sendTransaction({from: creatorAddress, value: 1000})
         })
         .then(transferResult => {
           return multiSigWalletInstance.addOwner(firstOwnerAddress);
         })
        .then(addOwnerResult => {
          return multiSigWalletInstance.withdraw(100, {from: firstOwnerAddress});
        })
        .then(firstWithdrawResult => {
          return multiSigWalletInstance.signTransaction(1);
        })
        .then(secondWithdrawResult => {
          return multiSigWalletInstance.signTransaction(1);
        })
        .then(signResult => {
          assert.fail();
        })
        .catch(error => {
          assert.notEqual(error.message, "assert.fail()", "Transaction was not reverted after creator signed a transaction");
        });
  });

});
