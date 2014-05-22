"use strict"

mongoose = require 'mongoose'
mongoose.connect require('../config').MONGODB_URI

models = {}

mongoose.connection.once 'open', ->
  buildSchema = mongoose.Schema

  postSchema = mongoose.Schema
    company: String
    field: String
    value: String

  Post = mongoose.model('Post', postSchema)

  deviceSchema = mongoose.Schema
    company: String
    build:
      brand: String
      model: String

  Device = mongoose.model('Device', deviceSchema)

  issueSchema = mongoose.Schema
    type: String
    occuredAt: Date
    createdAt:
      type: Date
      default: Date.now
    build:
      board: String
      brand: String
      device: String
      display: String
      hardware: String
      manufacturer: String
      model: String
      product: String
      tags: String
      version:
        codename: String
        incremental: String
        release: String
        sdk: String
        sdk_int: Number
    reporter: String

  issueSchema.pre 'save', (next) ->
    if @build?.brand? and @build?.model?
      next()
    else
      next(new Error('Mandatory fields missed!'))

  Issue = mongoose.model('Issue', issueSchema)

  models.Issue = Issue
  models.Device = Device
  models.Post = Post

exports.init = (req, res, next) ->
  req.models = models
  req.mongo = mongoose.connection
  next()
