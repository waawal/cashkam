Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
require('lib/waypoints')
require 'lib/jquery.masonry.min'

class List extends Spine.Controller


  elements:
    '#maincontent': 'maincontent'

  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    Ad.bind("create",  @appendOne)

    @append @maincontent

    @maincontent.masonry
        itemSelector: ".preview"
        isFitWidth: true
    
    @wayPointOpts =
      offset: ->
        height = ($.waypoints('viewportHeight') - $(this).height())
        #if height > 6000
        #  multiplier = 0.95
        #if height > 12000
        #  multiplier = 0.97
        #if height > 24000
        #  multiplier = 0.99
        #else
        multiplier = 0.98
        return height * multiplier
      onlyOnScroll: true
    @maincontent.waypoint(
      (event, direction) => @infiniteScroll(event, direction)
      @wayPointOpts
      )

    # # # # #
    # Global Events attached to Spine
    Spine.bind 'refreshList', -> @refreshList
    Spine.bind 'global:new-search', -> @refreshList
    # # # # #


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