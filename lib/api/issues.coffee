"use strict"

exports = module.exports =
  list: (req, res) ->
    req.models.Issue.find {}, (err, issues) ->
      if err
        res.send 500
      else
        res.json issues

  get: (req, res) ->
    req.models.Issue.findById req.params.id, (err, issue) ->
      if err
        res.send 500
      else
        res.json issue

  create: (req, res) ->
    occuredAt = new Date()
    if req.body.occuredAt
      occuredAt.setTime req.body.occuredAt
    req.models.Issue.create {
      type: req.body.type or 'SYSTEM_RESTART'
      occuredAt: occuredAt
      build: req.body.build or {}
      reporter: req.body.reporter or null
    }, (err, issue) ->
      if err
        res.send 500
      else
        res.json issue

  delete: (req, res) ->
    req.models.Issue.findOneAndRemove req.params.id, (err) ->
      res.send(if err then 500 else 200)
