Spine = require('spine')
L = require ('lib/leaflet')
require('lib/jquery-ui')

class Map extends Spine.Controller
  #className: "side-map"
  elements:
    '#map': 'mapbox'
    '#browse-button': 'browseButton'
    '#map-frame': 'mapframe'

  events:
    "click #browse": "search"

  constructor: ->
    super
    @browseButton.html '<button id="browse">Browse</button>'

    
    @map = new @createMap
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @map.addLayer(marker)
    Spine.bind 'removeMarker', (marker) => @map.removeLayer(marker)
    # # # # #

    @mapframe.append @mapbox
    @append @mapframe, @browseButton

  createMap: =>
    map = L.map('map',
      center: [59.712097173322924, 17.9296875]
      zoom: 9
      maxZoom: 14
      minZoom: 3
      attributionControl: false
      zoomControl: false
      doubleClickZoom: true
      )
    zoom = new L.Control.Zoom(position: 'topright')
    zoom.addTo(map)

    # Raster tiles
    L.tileLayer(
      'http://{s}.tiles.mapbox.com/v3/mapbox.mapbox-light/{z}/{x}/{y}.png',
        maxZoom: 14
        attributionControl: false
        #updateWhenIdle: true
    ).addTo(map)

    map.measure = new L.Control.Scale
      metric: true
      imperial: false
      maxWidth: 200
    map.measure.addTo(map)

    map.locate(
      setView: true
      maxZoom: 13
      enableHighAccuracy: true
      )

    map.on('locationfound', (e) =>
      @initialLocation(e.latlng)
      )

    map.meicon = L.icon
      iconUrl: "http://cdn1.iconfinder.com/data/icons/gnomeicontheme/32x32/stock/generic/stock_person.png"
      iconSize: [32, 32]
      iconAnchor: [16, 16]
    
    map.on('click', (e) =>
      map.panTo(e.latlng)
      )
    map


  initialLocation: (latlng) =>
    @map.panTo(latlng)
    @location = latlng
    @map.meMarker = new L.marker(@location,
      icon: @map.meicon
      clickable: false
      title: "You!"
      )
    @map.meMarker.addTo(@map)
    @trigger "search"


  search: (e) =>
    e.preventDefault()
    @trigger "search"


module.exports = Map