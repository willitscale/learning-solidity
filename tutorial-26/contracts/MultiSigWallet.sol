pragma solidity ^0.4.0;

contract MultiSigWallet {

    address private _owner;
    mapping(address => uint8) private _owners;

    uint _transactionIdx;
    uint[] private _pendingTransactions;

    struct Transaction {
      address from;
      address to;
      uint amount;
      uint8 signatureCount;
      mapping (address => uint8) signatures;
    }

    mapping(uint => Transaction) _transactions;
    uint8 constant private _sigRequiredCount = 2;

    modifier validOwner() {
        require(msg.sender == _owner || _owners[msg.sender] == 1);
        //require(_owners[msg.sender] == 1);
        _;
    }

    event DepositFunds(address from, uint amount);
    event TransactionCreated(address from, address to, uint amount, uint transactionId);
    event TransactionCompleted(address from, address to, uint amount, uint transactionId);
    event TransactionSigned(address by, uint transactionId);

    function MultiSigWallet()
        public {
        // Set master contract owner
        _owner = msg.sender;
        //_owners[msg.sender] = 1;
    }

    function addOwner(address owner)
        // isOwner
        validOwner
        public {
        _owners[owner] = 1;
    }

    function removeOwner(address owner)
        // isOwner
        // The owner validation was missing
        validOwner
        public {
        _owners[owner] = 0;
    }

    function ()
        public
        payable {
        DepositFunds(msg.sender, msg.value);
    }

    function send()
      public
      payable{}

    function withdraw(uint amount)
        validOwner
        public {
        transferTo(msg.sender, amount);
    }

    function transferTo(address to, uint amount)
        validOwner
        public {
        require(address(this).balance >= amount);
        uint transactionId = _transactionIdx++;
        Transaction memory transaction;
        transaction.from = msg.sender;
        transaction.to = to;
        transaction.amount = amount;
        transaction.signatureCount = 0;
        _transactions[transactionId] = transaction;
        _pendingTransactions.push(transactionId);
        TransactionCreated(msg.sender, to, amount, transactionId);
    }

    function getActiveTransactions()
      validOwner
      view
      public
      returns (uint[]) {
      return _pendingTransactions;
    }

    function signTransaction(uint transactionId)
      validOwner
      public {

      Transaction storage transaction = _transactions[transactionId];

      // Transaction must exist
      require(0x0 != transaction.from);
      //Creator cannot sign this
      require(msg.sender != transaction.from);
      // Has not already signed this transaction
      require(transaction.signatures[msg.sender] == 0);

      transaction.signatures[msg.sender] = 1;
      transaction.signatureCount++;

      TransactionSigned(msg.sender, transactionId);

      if (transaction.signatureCount >= _sigRequiredCount) {
        require(address(this).balance >= transaction.amount);
        transaction.to.transfer(transaction.amount);
        TransactionCompleted(msg.sender, transaction.to, transaction.amount, transactionId);
        deleteTransaction(transactionId);
      }
    }

    function deleteTransaction(uint transactionId)
      validOwner
      public {
      uint8 replace = 0;
      require(_pendingTransactions.length > 0);
      for(uint i = 0; i < _pendingTransactions.length; i++) {
          if (1 == replace) {
              _pendingTransactions[i-1] = _pendingTransactions[i];
          } else if (_pendingTransactions[i] == transactionId) {
              replace = 1;
          }
      }
      assert(replace == 1);
      // Created an Overflow
      delete _pendingTransactions[_pendingTransactions.length - 1];
      _pendingTransactions.length--;
      delete _transactions[transactionId];
    }

    function getPendingTransactionLength()
      public
      view
      returns (uint) {
      return _pendingTransactions.length;
    }

    function walletBalance()
        constant
        public returns (uint) {
        return address(this).balance;
    }
}
