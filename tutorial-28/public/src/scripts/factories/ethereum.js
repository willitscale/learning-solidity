angular.module('learningSolidity.factories.ethereum', [])
  .factory("EthereumContract", function () {
    const Eth = require('ethjs-query');
    const EthContract = require('ethjs-contract');
    return {
      contract: function(abi, address) {
        const eth = new Eth(web3.currentProvider);
        const contract = new EthContract(eth);
        return contract(abi).at(address);
      }
    };
  });
