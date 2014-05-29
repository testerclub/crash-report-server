'use strict'

require('http').globalAgent.maxSockets = 10000

exports = module.exports =
  MONGODB_URI: process.env.MONGOLAB_URI or 'mongodb://localhost/devicecrashes'
