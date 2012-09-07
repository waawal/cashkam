Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'
$ = Spine.$
require 'lib/jquery.wookmark'

class List extends Spine.Controller


  elements:
    '#maincontent': 'maincontent'

  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    Ad.bind("create",  @addOne)
    @maincontent = $('#maincontent')
    @append @maincontent
    


  addOne: (item) =>

    if item
      @ads.wookmarkClear() if @ads
      listitem = new ListItem(item: item)
      @maincontent.append(listitem.render().el)
      @ads = $('.preview')
      @ads.wookmark(
        offset: 20
        itemWidth: 160
        autoResize: true
        container: $('#maincontent')
        )

  addAll: =>
    #@$el.empty()
    @maincontent.empty()
    
    Ad.each(@addOne)
    #@ads.wookmarkClear()
    #@ads = $('.preview')
    #@ads.wookmark(
    #  offset: 20
    #  itemWidth: 160
    #  autoResize: true
    #  container: @el
    #  )


module.exports = List