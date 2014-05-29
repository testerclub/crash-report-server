"use strict"

_ = require 'underscore'

exports = module.exports =
  list: (req, res) ->
    if req.param('brand')? and req.param('model')?
      req.models.Device.findOne
        'build.brand': req.param('brand')
        'build.model': req.param('model')
      , 'company', (err, device) ->
        if device?
          req.models.Post.find
            company: device.company
          , (err, posts) ->
            if err
              res.send 500
            else
              categories = _.map _.groupBy(posts, 'field'), (posts, field) ->
                [field, _.map(posts, (post) -> post.value)]
              res.json _.object(categories)
        else
          res.send 404
    else
      req.models.Post.find {}, (err, posts) ->
        if err
          res.send 500
        else
          res.json posts

  get: (req, res) ->
    req.models.Post.findById req.params.id, (err, post) ->
      if err
        res.send 500
      else
        res.json post

  create: (req, res) ->
    req.models.Post.create {
      company: req.body.company
      field: req.body.field or 'text'
      value: req.body.value
    }, (err, post) ->
      if err
        res.send 500
      else
        res.json post

  update: (req, res) ->
    updates = $set : {}
    if req.body.company?
      updates.$set.company = req.body.company
    if req.body.field?
      updates.$set.field = req.body.field
    if req.body.value?
      updates.$set.value = req.body.value
    req.models.Post.findByIdAndUpdate req.params.id, updates, (err, post) ->
      if err
        res.send 500
      else
        res.json post

  delete: (req, res) ->
    req.models.Post.findByIdAndRemove req.params.id, (err) ->
      res.send(if err then 500 else 200)
