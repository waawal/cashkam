Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
require('lib/waypoints')
require 'lib/jquery.masonry.min'
Manager = require('spine/lib/manager')

class List extends Spine.Controller

  className: "list-wrapper"

  #el: $('#list-wrapper')

  elements:
    '#maincontent': 'maincontent'

  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    Ad.bind("create",  @appendOne)
    @html '<div id="maincontent"></div>'

    @append @maincontent

    @maincontent.masonry
        itemSelector: ".preview"
        isFitWidth: true
    
    @wayPointOpts =
      offset: ->
        height = ($.waypoints('viewportHeight') - $(this).height())
        multiplier = 0.98
        return height * multiplier
      onlyOnScroll: true

    @maincontent.waypoint(
      (event, direction) => @infiniteScroll(event, direction)
      @wayPointOpts
      )

    # # # # #
    # Global Events attached to Spine
    #Spine.bind 'refreshList', -> @refreshList
    #Spine.bind 'global:new-search', -> @refreshList
    # # # # #

  activate: ->
    @el.addClass("active")
    @maincontent.masonry( 'destroy' )
    @maincontent.masonry()
    @maincontent.waypoint @wayPointOpts
    @
  deactivate: ->
    @maincontent.waypoint "remove"
    @el.removeClass("active")
    @

  refreshList: (refreshType) =>
    @$el.fadeOut('fast')


  appendOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      @maincontent.append( brick.el ).masonry( 'appended', brick.el, false )


  addOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      brick


  infiniteScroll: (e, direction) ->
    @maincontent.waypoint "remove"
    Spine.trigger('global:fetchAds')
      

  addAll: =>
    @appendOne(ad) for ad in Ad.all()[Ad.count() - 30..]
    @maincontent.masonry( 'reload' )
    @maincontent.waypoint @wayPointOpts

module.exports = List