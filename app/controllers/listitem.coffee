Spine = require('spine')
L = require ('lib/leaflet')
L.Icon.Default.imagePath = 'http://leaflet.cloudmade.com/dist/images/'

class ListItem extends Spine.Controller
  

  className: "preview"


  events:
    "mouseenter": "addMarker"
    "mouseleave": "removeMarker"

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)
    Spine.bind 'global:position-changed', (newPosition) => @updateDistance(newPosition)

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
    Spine.trigger('showMarker', @marker)
    #@log "addMarker"
  removeMarker: =>
    #@log @marker
    Spine.trigger('removeMarker', @marker)
    #@log "removeMarker"
  
  updateDistance: (newPosition) =>
    latlng = newPosition.target.dragging._marker._latlng
    $('#distance').html(@calculateDistance(latlng.lat, latlng.lng, @item.latlng[0], @item.latlng[1]).toString())

  # Util methods
  calculateDistance: (lat1, lon1, lat2, lon2, unit='K') ->
    radlat1 = Math.PI * lat1 / 180
    radlat2 = Math.PI * lat2 / 180
    radlon1 = Math.PI * lon1 / 180
    radlon2 = Math.PI * lon2 / 180
    theta = lon1 - lon2
    radtheta = Math.PI * theta / 180
    dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
    dist = Math.acos(dist)
    dist = dist * 180 / Math.PI
    dist = dist * 60 * 1.1515
    dist = dist * 1.609344  if unit is "K"
    dist = dist * 0.8684  if unit is "N"
    Math.round(Number(dist)) + " km"

module.exports = ListItem