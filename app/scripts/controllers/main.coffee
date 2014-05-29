"use strict"

angular.module("reportApp").controller("MainCtrl", [
  '$scope'
  'Device'
  ($scope) ->
    $scope.awesomeThings = [
      "HTML5 Boilerplate"
      "AngularJS"
      "Karma"
    ]
    return
]).controller("DeviceCtrl", [
  '$scope'
  "$location"
  'Device'
  ($scope, $location, Device) ->
    $scope.devices = Device.query()
    $scope.removeDevice = (device) ->
      device.$remove({deviceId: device._id})
      $scope.devices = Device.query()
    $scope.addDevice = ->
      $location.path("/devices/new")
    return
]).controller("DeviceDetailCtrl", [
  "$scope"
  "$routeParams"
  "$location"
  "Device"
  ($scope, $routeParams, $location, Device) ->
    if $routeParams.deviceId is 'new'
      $scope.device = new Device
        company: ''
        build:
          brand: ''
          model: ''
    else
      $scope.device = Device.get({deviceId: $routeParams.deviceId})
    $scope.save = (device)->
      if device._id?
        device.$save {deviceId: device._id}, (res) ->
          $location.path("/devices")
      else
        device.$save device, (res) ->
          $location.path("/devices")      
    return
]).controller("PostCtrl", [
  '$scope'
  "$location"
  'Post'
  ($scope, $location, Post) ->
    $scope.posts = Post.query()
    $scope.remove = (post) ->
      post.$remove({postId: post._id})
      $scope.posts = Post.query()
    $scope.add = ->
      $location.path("/posts/new")
    return
]).controller("PostDetailCtrl", [
  "$scope"
  "$routeParams"
  "$location"
  "Post"
  ($scope, $routeParams, $location, Post) ->
    if $routeParams.postId is 'new'
      $scope.post = new Post
        company: ''
        field: 'text'
        value: ''
    else
      $scope.post = Post.get({postId: $routeParams.postId})
    $scope.save = (post)->
      if post._id?
        post.$save {postId: post._id} , (res) ->
          $location.path("/posts")
      else
        post.$save post, (res)->
          $location.path("/posts")
    return
])