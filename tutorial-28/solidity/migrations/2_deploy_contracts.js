var AddressBook = artifacts.require("./AddressBook.sol");

module.exports = deployer => {
  deployer.deploy(AddressBook);
};
