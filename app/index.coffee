require('lib/setup')
Spine = require('spine')
Ads = require 'controllers/ads'
List = require 'controllers/list'
Ad = require 'models/ad'
$ = Spine.$


class App extends Spine.Controller
  events:
    "a hover": "preventDefault"
  constructor: ->
    super
    @ads = new Ads(el: $("#sidebar"))
    @list = new List(el: $("#contentwrapper"))
    @append @ads, @list
    @ad = Ad

  preventDefault: (event) =>
    event.preventDefault()

module.exports = App
