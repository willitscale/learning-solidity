require('angular/angular');
require('angular-route/angular-route');

require('./controllers/controllers');
require('./factories/factories');

angular.module('learningSolidity', [
  'ngRoute',
  'learningSolidity.controllers',
  'learningSolidity.factories'
])
.config(['$routeProvider', function($routeProvider) {
    $routeProvider
    .when('/', {
      templateUrl: 'templates/home.html'
    });
  }]);
