Spine = require('spine')
L = require ('lib/leaflet')
L.Icon.Default.imagePath = 'http://leaflet.cloudmade.com/dist/images/'
require('spine/lib/route')

class ListItem extends Spine.Controller
  

  className: "preview"

  elements:
    '.distance': 'distance'
    #'.icon-info-sign': 'info'

  events:
    "click .distance-box": "addMarker"
    "click .icon-info-sign": "showDetails"

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)
    Spine.bind 'global:position-changed', (newPosition) => @updateDistance(newPosition)
    @point = new L.LatLng(@item.latlng[0], @item.latlng[1])

  # Render an element
  render: (item) =>
    @item = item if item
    @item.distance = distance = Math.round(Number(@point.distanceTo(Spine.massforstroelse.currentLocation))/1000)
    @html(@template(@item))
    @

  template: (item) ->
    require('views/brick')(item)

  # Called after an element is destroyed
  remove: ->
    @el.remove()

  showDetails: =>
    @navigate("/ad", @item.id)

  # Picked up by map Controller    WARNING - Global Events!
  addMarker: =>
    @marker = new L.Marker(@item.latlng, clickable: false)
    Spine.trigger('showMarker', @marker)
    #@log "addMarker"
  removeMarker: =>
    #@log @marker
    Spine.trigger('removeMarker', @marker)
    #@log "removeMarker"
  
  updateDistance: (newPosition) =>
    latlng = newPosition.target.dragging._marker._latlng
    #distance = Math.round(Number(@point.distanceTo(latlng))/1000) + " km"
    distance = Math.round(Number(@point.distanceTo(latlng))/1000)#@point.distanceTo(latlng)
    @distance.html distance + " km"

module.exports = ListItem