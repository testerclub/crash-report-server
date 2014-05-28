"use strict"

angular.module("reportApp").factory('Device', [
  '$resource'
  ($resource) ->
    $resource('api/devices/:deviceId', {}, {
        query:
          method: 'GET'
          isArray: true
      })
]).factory('Post', [
  '$resource'
  ($resource) ->
    $resource('api/posts/:postId', {}, {
        query:
          method: 'GET'
          isArray: true
      })
])
