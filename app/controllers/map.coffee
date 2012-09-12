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
    @setupSlider()
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @map.addLayer(marker)
    Spine.bind 'removeMarker', (marker) => @map.removeLayer(marker)
    # # # # #

    @mapframe.append @mapbox
    @append @mapframe, @meters, @slider, @browseButton


  setupSlider: =>
    @slider.html "" # or else the slider wont be able to init
    @slider = $(@slider).slider
      orientation: "horizontal"
      #range: "min"
      min: 500
      max: 100000
      step: 500
      value: 80000
      slide: (event, ui) =>
        weight = 100000
        rad = (weight-ui.value) or 500
        @circle.setRadius(rad)
        @updateMeasure()
      stop: (event, ui) =>
        zoomAmount = (@map.getBoundsZoom(@circle.getBounds(), true))-2
        #@log (zoomAmount is @map.getZoom()) # ->(inside = true)
        unless @map.getZoom() is zoomAmount # only set center and zoom if needed
          @map.panTo(@circle.getLatLng())
          @map.setZoom(zoomAmount)
        if L.Browser.gecko
          # bug in FF
          @map.setView(@circle.getLatLng(), zoomAmount, false)

  createMap: =>
    map = L.map('map',
      center: [59.712097173322924, 17.9296875]
      zoom: 7
      #maxZoom: 13
      minZoom: 3
      attributionControl: false
      zoomControl: false
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

    @circle = L.circle(map.getCenter(), 20000,
      fillOpacity: 0.3
      fillColor: "#fff"
      #stroke: false
      weight: 2
      opacity: 0.6
      color: '#000'
      clickable: false
      ).addTo(map)

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
      @circle.setLatLng(e.latlng)
      )

    #map.on 'exitFullscreen', (e) =>
    #  @delay((-> @map.fitBounds(@circle.getBounds())), 1000)

    map.on 'viewreset', (e) =>
      @updateMeasure
    map


  initialLocation: (latlng) =>
    @circle.setLatLng(latlng)
    @map.panTo(latlng)
    zoomAmount = @map.getBoundsZoom(@circle.getBounds(), true) # ->(inside = true)
    @map.setZoom((zoomAmount - 3))
    @updateMeasure()
    @trigger "initialLocation"
    #@map.fitBounds(@circle.getBounds())


  updateMeasure: =>
    distance = @circle.getRadius()
    if distance >= 1000
      distance = (Math.round(distance / 100) / 10).toFixed(0)
      unit = "km"
    else
      unit = "m"

    @meters.html "#{distance} #{unit}"
    @meters.show()


  search: (e) =>
    e.preventDefault()
    @trigger "search"


module.exports = Map