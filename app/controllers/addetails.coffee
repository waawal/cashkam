Spine = require('spine')
Ad = require 'models/ad'
require('spine/lib/route')
$ = Spine.$
Manager = require('spine/lib/manager')

class AdDetails extends Spine.Controller

  #el: $("#ad-details")
  className: "ad-details"

  constructor: ->
    super

    #@routes
    #  "/ad/:id": (params) ->
    #    @render(params.id) if params.id
    #    @activate()

  render: (id) ->
    if id
      @item = Ad.find(id)
      #@item.distance = Math.round(Number(@point.distanceTo(Spine.massforstroelse.currentLocation))/1000)
      @html(@template(@item))
      @

  remove: ->
    @el.remove()

  template: (item) ->
    require('views/brick')(item)


  activate: (params) ->
    @render(params.id)
    @el.addClass("active")
    @
  deactivate: ->
    @el.removeClass("active")
    @


module.exports = AdDetails