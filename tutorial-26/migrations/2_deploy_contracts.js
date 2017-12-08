var MultiSigWallet = artifacts.require("./MultiSigWallet.sol");

module.exports = deployer => {
  deployer.deploy(MultiSigWallet);
};
