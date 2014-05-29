'use strict'

require('http').globalAgent.maxSockets = 10000

exports = module.exports =
  MONGODB_URI: 'mongodb://localhost/devicecrashes'