pragma solidity ^0.4.0;

interface Letter {
    function n() public returns (uint);
}

contract A is Letter {
    function n()
        public
        returns (uint) {
        return 1;    
    }
}

contract B is A {}

contract C is Letter {
    function n()
        public
        returns (uint) {
        return 2;
    }
    
    function x() 
        public
        returns (string) {
        return "x";        
    }
}

contract Alphabet {
    
    Letter[] private letters;
    
    event Printer(uint);
    
    function Alphabet()
        public {
        letters.push(new A());
        letters.push(new B());
        letters.push(new C());
    }
    
    function loadRemote(address _addrX,
                        address _addrY,
                        address _addrZ)
        public {
        letters.push(Letter(_addrX));
        letters.push(Letter(_addrY));
        letters.push(Letter(_addrZ));    
    }
    
    function printLetters()
        public {
        for(uint i = 0; i < letters.length; i++) {
            Printer(letters[i].n());
        }    
    }
}