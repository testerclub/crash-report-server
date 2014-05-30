"use strict"

_ = require 'underscore'
request = require 'request'

devices = {}
posts = {}

URL_PREFIX = 'https://raw.githubusercontent.com/xiaocong/weibo-report/master'
URL_DEVICES = "#{URL_PREFIX}/devices.md"

exports = module.exports =
  list: (req, res) ->
    if req.param('brand')? and req.param('model')?
      req.models.Device.update {
            'build.brand': req.param('brand')
            'build.model': req.param('model')
          }, {
            $inc: {count: 1}
          }, {
            upsert: true
          }, (err, num) ->
      for company, builds of devices
        for build in builds
          if build.brand is req.param('brand') and build.model is req.param('model')
            return res.json posts[company] or {}
    res.send 404

  data: ->
    devices: devices
    posts: posts

  reload: (req, res) ->
    console.log req.body
    retrieveDevices()
    res.send 200

retrieveDevices = ->
  request.get URL_DEVICES, (error, response, body) ->
    if !error and response.statusCode is 200
      lines = body.match(/[^\r\n]+/g)
      tmpDevices = {}
      company = null
      for line in lines
        if m = /^##\s+(.+)\s*/g.exec(line)
          company = m[1].trim()
          retrieveWeibo company  # retrieve weibo content of the company
          tmpDevices[company] = []
        else if m = /^-\s+([\w\s]+)\|([\w\s]+)/g.exec(line)
          if company?
            tmpDevices[company].push {brand: m[1].trim(), model: m[2].trim()}
      devices = tmpDevices

retrieveWeibo = (company) ->
  request.get "#{URL_PREFIX}/#{encodeURIComponent(company)}.md", (error, response, body) ->
    if !error and response.statusCode is 200
      lines = body.match(/[^\r\n]+/g)
      values = {}
      field = null
      for line in lines
        if m = /^##\s+(.+)\s*/g.exec(line)  # ## field_name
          field = m[1].trim()
          values[field] = []
        else if m = /^-\s+!\[.*\]\((.+)\)/g.exec(line)  # image: ![xxx](xxx)
          values[field].push m[1].trim()
        else if m = /^-\s+(.+)\s*/g.exec(line)
          values[field].push m[1].trim()
      posts[company] = values

retrieveDevices()