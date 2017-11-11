var SafeMath = artifacts.require("./SafeMath.sol");
var MyToken = artifacts.require("./MyToken.sol");
var Addresses = artifacts.require("./Addresses.sol");
var Crowdsale = artifacts.require("./Crowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, MyToken);
  deployer.deploy(Addresses);
  deployer.link(Addresses, MyToken);
  deployer.deploy(MyToken).then(function(){
    return deployer.deploy(
      Crowdsale,
      MyToken.address,
      web3.eth.blockNumber,
      web3.eth.blockNumber+1000,
      web3.toWei(1, 'ether'),
      1
    ).then(function(){});
  });
};
