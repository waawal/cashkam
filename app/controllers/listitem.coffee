Spine = require('spine')
L = require ('lib/leaflet')
L.Icon.Default.imagePath = 'http://leaflet.cloudmade.com/dist/images/'

class ListItem extends Spine.Controller
  

  className: "preview"


  events:
    "mouseenter img": "addMarker"
    "mouseleave img": "removeMarker"

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  # Render an element
  render: (item) =>
    @item = item if item
    @html(@template(@item))
    @

  template: (item) ->
    require('views/list')(item)

  # Called after an element is destroyed
  remove: ->
    @el.remove()

  # Picked up by map Controller    WARNING - Global Events!
  addMarker: =>
    @marker = new L.Marker(@item.latlng)
    #Spine.trigger('showMarker', @marker)
    @log "addMarker"
  removeMarker: =>
    #@log @marker
    #Spine.trigger('removeMarker', @marker)
    @log "removeMarker"
    
module.exports = ListItem