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
    Ad.bind("create",  @addOne)
    #@maincontent = $('#maincontent')

    @append @maincontent

    # # # # #
    # Global Events attached to Spine
    Spine.bind 'refreshList', => @refreshList()
    # # # # #


  refreshList: =>
    @log "refresh"
    @maincontent.masonry('reloadItems')
    


  addOne: (item) =>
    if item
      listitem = new ListItem(item: item)
      brick = listitem.render()
      @maincontent.append(brick.el)

      

  addAll: =>
    @maincontent.empty()
    Ad.each(@addOne)
    @maincontent.imagesLoaded =>
      @masonry = @maincontent.masonry
        itemSelector: ".preview"
        #columnWidth: 200
        #gutterWidth: 20
        #isFitWidth: true
        isAnimated: true
        animationOptions:
          duration: 280
          easing: "linear"
          queue: false
    @refreshList()



module.exports = List