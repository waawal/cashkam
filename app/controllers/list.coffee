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

    # # # # #
    # Global Events attached to Spine
    Spine.bind 'refreshList', -> @refreshList
    # # # # #


  refreshList: (refreshType) =>
    #@log "refresh"
    #if refreshType is 'refresh'
    @maincontent.masonry('reload')
    #@maincontent.masonry('reload')
    #@delay(, 600)    #TODO: Make it leaner!
    #else
    
    
    


  addOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      @maincontent.append(brick.el)
      @maincontent.masonry('reload')

      

  addAll: =>
    @maincontent.empty()
    @maincontent.masonry
        itemSelector: ".preview"
    Ad.each(@addOne)
    @maincontent.masonry('reloadItems')
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