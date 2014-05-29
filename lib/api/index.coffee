"use strict"

logger = require("../logger")

exports.awesomeThings = (req, res) ->
  res.json [
    "HTML5 Boilerplate"
    "AngularJS"
    "Karma"
    "Express"
  ]

exports.issues = require './issues'
exports.devices = require './devices'
exports.posts = require './posts'

exports.setup = ->
  require('../models').init
