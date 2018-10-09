# Learning Solidity Tutorial 31

What you'll need:
- Download the web3j command line client from [here](https://github.com/web3j/web3j/releases/tag/v3.6.0)
- Download the solc binaries from [here](https://github.com/ethereum/solidity/releases)

Web3j Documentation : https://docs.web3j.io/

Building the solidity:

```
solc src/main/resources/solidity/AddressBook.sol --bin --abi --optimize -o src/main/resources/out
```

Building the Java:
```
web3j solidity generate src/main/resources/out/AddressBook.bin src/main/resources/out/AddressBook.abi -o src/main/java -p youtube.solidity.learning.contracts
```