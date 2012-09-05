Spine = require('spine')
Ad = require 'models/ad'
ListItem = require 'controllers/listitem'

class List extends Spine.Controller


  constructor: ->
    super
    Ad.bind("refresh", @addAll)
    Ad.bind("create",  @addOne)


  addOne: (item) =>
    list = new ListItem(item: item)
    @append(list.render().el)


  addAll: =>
    @$el.empty()
    Ad.each(@addOne)


module.exports = List