require('lib/setup')
Spine = require('spine')
Ads = require 'controllers/ads'
List = require 'controllers/list'
Ad = require 'models/ad'
$ = Spine.$


class App extends Spine.Controller
  constructor: ->
    super
    @ads = new Ads(el: $("#sidebar"))
    @list = new List(el: $("#maincontent"))
    @append @ads, @list
    @ad = Ad

module.exports = App
