Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
require('lib/waypoints')
require 'lib/jquery.masonry.min'
#require 'lib/gfx'
#require 'lib/gfx.flip'

class List extends Spine.Controller


  elements:
    '#maincontent': 'maincontent'

  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    #Ad.bind("refresh", @refreshList)
    Ad.bind("create",  @appendOne)
    #Ad.bind("create",  @refreshList)
    #@maincontent = $('#maincontent')

    @append @maincontent

    @maincontent.masonry
        itemSelector: ".preview"
        isFitWidth: true
        #isAnimated: true
        #animationOptions:
        #  duration: 280
        #  easing: "linear"
        #  queue: true
    
    @wayPointOpts =
      offset: ->
        height = ($.waypoints('viewportHeight') - $(this).height())
        if height > 6000
          multiplier = 0.95
        if height > 12000
          multiplier = 0.97
        if height > 24000
          multiplier = 0.99
        else
          multiplier = 0.9
        return height * multiplier
      #continuous: true
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
      #@maincontent.append()
      @maincontent.append( brick.el ).masonry( 'appended', brick.el, false )
      #@maincontent.masonry('reloadItems')
      #@maincontent.masonry('reload')

  addOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      brick
      #@maincontent.append(brick.el)#.masonry('reload')
      #@maincontent.append( brick.el ).masonry( 'appended', brick.el, false )
      #@log $.waypoints()


  infiniteScroll: (e, direction) ->
    #@log e
    @maincontent.waypoint "remove"
    Spine.trigger('global:fetchAds')
      

  addAll: =>
    #@maincontent.empty()
    #@maincontent.masonry('reload')
    ads = [(@appendOne(ad)) for ad in Ad.all()]
    #ads = [@maincontent.append(@addOne(ad).$el) for ad in Ad.all()]
    #@log @maincontent
    #@log ads
    @maincontent.masonry( 'reload' )
    @maincontent.waypoint @wayPointOpts
    #@maincontent.imagesLoaded =>
    #  @maincontent.masonry('reload')
      
  #@maincontent.masonry('reload')
    #@maincontent.masonry('reload')
    #@maincontent.imagesLoaded =>
    #  @maincontent.masonry
    #    itemSelector: ".preview"
        #columnWidth: 200
        #gutterWidth: 20
        #isFitWidth: true
        #isAnimated: true
        #animationOptions:
        #  duration: 280
        #  easing: "linear"
        #  queue: false
      #@masonryLoaded = true
    #@maincontent.masonry('reload')



module.exports = List