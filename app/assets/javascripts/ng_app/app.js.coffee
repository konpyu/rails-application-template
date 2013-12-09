angular.module('__APPNAME__', ['ngRoute', 'ngSanitize', 'ngResource'])
.config (['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->

  $locationProvider.html5Mode(true).hashPrefix('!')

  $routeProvider
    .when('/',      { controller: 'PagesCtrl',  templateUrl: '/template/pages/index' })
    .when('/about', { controller: 'PagesCtrl',  templateUrl: '/template/pages/about' })
    .when('/_404',  { controller: 'PagesCtrl',  templateUrl: '/template/pages/404'   })
    .otherwise({ redirectTo: '/_404' })
])
