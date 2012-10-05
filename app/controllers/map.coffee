Spine = require('spine')
L = require ('lib/leaflet')
require('lib/jquery-ui')

class Map extends Spine.Controller
  #className: "side-map"
  elements:
    '#map': 'mapbox'
    '#meters': 'meters'
    '#slider': 'slider'
    '#browse-button': 'browseButton'
    '#map-frame': 'mapframe'

  events:
    "click #browse": "search"

  constructor: ->
    super
    #@meters.css("visibility", "hidden")
    @meters.html "100 km"
    @browseButton.html '<button id="browse">Browse</button>'

    
    @map = new @createMap
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @map.addLayer(marker)
    Spine.bind 'removeMarker', (marker) => @map.removeLayer(marker)
    # # # # #

    @mapframe.append @mapbox
    @append @mapframe, @meters, @browseButton

  createMap: =>
    map = L.map('map',
      center: [59.712097173322924, 17.9296875]
      zoom: 7
      #maxZoom: 13
      minZoom: 3
      attributionControl: false
      zoomControl: true
      doubleClickZoom: false
      )

    # Raster tiles
    L.tileLayer(
      'http://{s}.tiles.mapbox.com/v3/mapbox.mapbox-light/{z}/{x}/{y}.png',
        maxZoom: 14
        attributionControl: false
        #updateWhenIdle: true
    ).addTo(map)
    # Full screen
    #fullScreen = new L.Control.FullScreen()
    #map.addControl(fullScreen)

    map.locate(
      setView: true
      maxZoom: 13
      enableHighAccuracy: true
      )

    map.on('locationfound', (e) =>
      @initialLocation(e.latlng)
      )


    map.on('click', (e) =>
      map.panTo(e.latlng)
      )

    #map.on 'exitFullscreen', (e) =>
    #  @delay((-> @map.fitBounds(@circle.getBounds())), 1000)

    map.on 'viewreset', (e) =>
      @updateMeasure
    map


  initialLocation: (latlng) =>
    @map.panTo(latlng)
    #zoomAmount = @map.getBoundsZoom(@circle.getBounds(), true) # ->(inside = true)
    #@map.setZoom((zoomAmount - 3))
    @updateMeasure()
    @trigger "initialLocation"
    #@map.fitBounds(@circle.getBounds())


  updateMeasure: =>
    #distance = @circle.getRadius()
    #if distance >= 1000
    #  distance = (Math.round(distance / 100) / 10).toFixed(0)
    #  unit = "km"
    #else
    #  unit = "m"
    distance = 4
    unit = "km"
    @meters.html "#{distance} #{unit}"
    @meters.show()


  search: (e) =>
    e.preventDefault()
    @trigger "search"


module.exports = Map