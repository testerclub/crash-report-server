"use strict"
angular.module("reportApp", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
]).config ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"
  ).when("/devices",
    templateUrl: "views/device.html"
    controller: "DeviceCtrl"
  ).when("/devices/:deviceId",
    templateUrl: "views/device-detail.html"
    controller: "DeviceDetailCtrl"
  ).when("/posts",
    templateUrl: "views/post.html"
    controller: "PostCtrl"
  ).when("/posts/:postId",
    templateUrl: "views/post-detail.html"
    controller: "PostDetailCtrl"
  ).otherwise redirectTo: "/"
  return
