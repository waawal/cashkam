require('lib/setup')
Spine = require('spine')
Ads = require 'controllers/ads'
List = require 'controllers/list'
Ad = require 'models/ad'
User = require 'models/user'
$ = Spine.$
require 'lib/blur'

Spine.massforstroelse = {} # NS

class App extends Spine.Controller

  constructor: ->
    super
    @ads = new Ads(el: $("#sidebar"))
    @list = new List(el: $("#contentwrapper"))
    @append @ads, @list
    @ad = Ad
    @user = User


    $('#myModal').modal
      backdrop: true
      show: false
    $('#myModal').on 'show', =>
      $('#wrapper').blurjs
        radius: 5
      #$('#footer-controls').fadeToggle('slow')
    $('#myModal').on 'hidden', =>
      $.blurjs 'reset'
      #$('#footer-controls').fadeToggle('slow')
  
    # Global listeners
    Spine.bind 'global:position-changed', (newPosition) =>
      Spine.massforstroelse.currentLocation = newPosition
    Spine.bind 'global:logIn', =>
      @log "Log in now!"

module.exports = App
