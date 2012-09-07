Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
require 'lib/jquery.wookmark'
require 'lib/gfx'
require 'lib/gfx.flip'

class List extends Spine.Controller


  elements:
    '#maincontent': 'maincontent'

  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    Ad.bind("create",  @addOne)
    @maincontent = $('#maincontent')

    @append @maincontent

    
  wookmarkOptions:
    offset: 20
    itemWidth: 222
    autoResize: true
    container: $("#contentwrapper")


  addOne: (item) =>
    if item
      #@ads.wookmarkClear() if @ads
      listitem = new ListItem(item: item)
      @maincontent.append(listitem.render().el)
      #@ads = $('.preview')
      #@ads.wookmark(
      #  offset: 20
      #  itemWidth: 220
      #  autoResize: true
      #  container: $('#maincontent')
      #  )
      @ads = $('.preview')
      @ads.wookmark(@wookmarkOptions)
      

  addAll: =>
    #@$el.empty()
    @ads.wookmarkClear() if @ads
    #delete @ads
    @maincontent.empty()
    
    Ad.each(@addOne)

    # GFX
    #for preview in $('.preview')
    #  $(preview).gfxFlip(width: 220).click ->
    #    $(this).trigger "flip"
    #@delay( () -> 
    #  @ads.wookmark(wookmarkOptions)
    #  , 200)
    #@trigger "rendered"


module.exports = List