angular.module('learningSolidity.controllers.addresses', ['ngRoute'])
    .config(['$routeProvider', function ($routeProvider) {
        $routeProvider
            .when('/addresses', {
                templateUrl: 'templates/addresses.html',
                controller: 'addressesController'
            });
    }])
    .controller("addressesController", ['$scope', 'EthereumContract', function ($scope, EthereumContract) {
        var addressBook = EthereumContract.contract(
            require('../contracts/addressbook.json'),
            '0x897c95fed51d8b89a8a57d8bbe7f1522bf530571'
        );

        var ethWeb3 = new Web3(web3.currentProvider);

        $scope.addresses = {};

        var params = {
            from: ethWeb3.eth.accounts[0],
            gas: "3000000"
        };

        $scope.add = function () {
            addAddress(
                $scope.address,
                $scope.alias
            );
        };

        $scope.remove = function (address) {
            removeAddress(address);
        };

        $scope.getAddresses = function (address) {
            getAddresses(address);
        };

        var addAddress = function (address, alias) {
            addressBook.addAddress(address, alias, params)
                .then(function () {
                    $scope.addresses[address] = alias;
                    $scope.$apply();
                })
                .catch(console.error);
        };

        var removeAddress = function (address) {
            addressBook.removeAddress(address, params)
                .then(function () {
                    delete $scope.addresses[address];
                    $scope.$apply();
                })
                .catch(console.error);
        };

        var getAddresses = function () {
            $scope.addresses = {};
            addressBook.getAddresses(params)
                .then(function (addresses) {
                    for (var i in addresses['0']) {
                        getAlias(addresses['0'][i], params);
                    }
                })
                .catch(console.error);
        };

        var getAlias = function (address) {
            addressBook.getAlias(address, params)
                .then(function (alias) {
                    $scope.addresses[address] = alias['0'];
                    $scope.$apply();
                })
                .catch(console.error);
        };

        var getState = function () {
            addressBook.getState(address, params)
                .then(function (state) {
                    $scope.state = state['0'];
                    $scope.$apply();
                })
                .catch(console.error);
        };

        getAddresses();
    }]);
