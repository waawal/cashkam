Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
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
    Ad.bind("create",  @addOne)
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
      @maincontent.append( brick.el ).masonry( 'appended', brick.el, true )
      @maincontent.masonry('reloadItems')
      #@maincontent.masonry('reload')

  addOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      #@maincontent.append(brick.el)#.masonry('reload')
      @maincontent.append( brick.el ).masonry( 'appended', brick.el, false )


      

  addAll: =>
    #@maincontent.empty()
    #@maincontent.masonry('reload')
    @addOne(ad) for ad in Ad.all()
    @maincontent.imagesLoaded =>
      @maincontent.masonry('reload')
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