require('lib/setup')
Spine = require('spine')
Ads = require 'controllers/ads'
List = require 'controllers/list'
AdDetails = require 'controllers/addetails'
Navigations = require ('controllers/navigations')
Users = require 'controllers/users'
Ad = require 'models/ad'
User = require 'models/user'
$ = Spine.$
require('spine/lib/route')
Manager = require('spine/lib/manager')

Spine.massforstroelse = {} # NS


class MainContents extends Spine.Stack
  controllers:
    adlist: List
    addetails: AdDetails

  routes:
    '/': 'adlist'
    '/ad/:id': 'addetails'


class App extends Spine.Controller

  constructor: ->
    super

    @menuBar = new Navigations
    @ads = new Ads(el: $("#sidebar"))
    @list = new MainContents(el: $("#contentwrapper"))

    #@list = new List(el: $("#contentwrapper"))
    @contentArea = $('<div id="content-area"></div>')
    
    @append @menuBar, @contentArea
    @contentArea.append @ads, @list
    @ad = Ad
    @user = User
    @users = Users


    #$('#myModal').modal
    #  backdrop: true
    #  show: false
      #$('#footer-controls').fadeToggle('slow')
  
    # Global listeners
    Spine.bind 'global:position-changed', (newPosition) =>
      Spine.massforstroelse.currentLocation = newPosition
    Spine.bind 'global:logIn', =>
      @log "Log in now!"
    Spine.bind 'global:loggedIn', =>
      @log "Logged in!"
    Spine.bind 'global:loggedOut', =>
      @log "Logged out!"



    Spine.Route.setup(history: true)

module.exports = App
