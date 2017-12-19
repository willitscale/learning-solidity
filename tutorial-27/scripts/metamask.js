$(document).ready(function(){
  if (typeof(window.web3) != 'undefined') {
    $('#no-meta-mask').hide();
    getBalances(web3.currentProvider);
  } else {
    $('#has-metamask').hide();
  }
});

function getBalances(provider) {
  var ethWeb3 = new Web3(provider);
  ethWeb3.eth.getAccounts(function (err, accounts) {
    for(var i = 0; i < accounts.length; i++) {
      var account = accounts[i];
      ethWeb3.eth.getBalance(account, function(err, balance) {
        addBalance(account, ethWeb3.fromWei(balance, 'ether'));
      })
    }
  });
}
function addBalance(account, balance) {
  console.log(account, balance);
  $('#balances').append('<div class="alert alert-primary" role="alert">' +
    '<p><i class="fa fa-address-book-o" aria-hidden="true"></i> <strong>' + account + '</strong></p>' +
    '<button type="button" class="btn btn-primary"><span class="badge badge-light" id="balance-count">' + balance + '</span>' +
    ' Ether</button> <button type="button" class="btn btn-success">Send</button></div>')
}
