pragma solidity ^0.4.0;

contract Gas {

    string[] dataStore;

    function cheap(uint a, uint b)
        public
        pure
        returns (uint c)
    {
        c = a + b;
    }

    function expensive(string memory val)
        public
    {
        dataStore.push(val);
    }

    function average()
        public
        view
        returns (string memory)
    {
        return dataStore[0];
    }

    function low()
        public
        pure
        returns (string memory)
    {
        string memory myString = "test";
        return myString;
    }
}
