var MultiSigWallet = artifacts.require("./MultiSigWallet.sol");

module.exports = function(deployer) {
  deployer.deploy(MultiSigWallet);
};
