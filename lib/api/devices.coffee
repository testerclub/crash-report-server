"use strict"

exports = module.exports =
  list: (req, res) ->
    req.models.Device.find {}, (err, devices) ->
      if err
        res.send 500
      else
        res.json devices

  get: (req, res) ->
    req.models.Device.findById req.params.id, (err, device) ->
      if err
        res.send 500
      else
        res.json device

  create: (req, res) ->
    req.models.Device.update {
      'build.brand': req.param('build').brand
      'build.model': req.param('build').model
    }, {
      company: req.param('company')
    }, {
      upsert: true
    }, (err, num) ->
      if err
        res.send 500
      else
        res.send 200

  update: (req, res) ->
    req.models.Device.findByIdAndUpdate req.params.id, {$set: {company: req.body.company, build: req.body.build}}, (err, device) ->
      if err
        res.send 500
      else
        res.json device

  delete: (req, res) ->
    req.models.Device.findOneAndRemove req.params.id, (err) ->
      res.send(if err then 500 else 200)
