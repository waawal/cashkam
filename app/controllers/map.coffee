Spine = require('spine')
L = require ('lib/leaflet')
require('lib/jquery-ui')
#$ = "lib/jq"



class Map extends Spine.Controller
  #className: "side-map"
  elements:
    '#map': 'mapbox'
    '#meters': 'meters'
    '#slider': 'slider'

  constructor: ->
    super
    @meters.hide()
    @meters.html "Distance"
    

    @map = new @createMap
    

    @slider.html "" # or else the slider wont be able to init
    $(@slider).slider
      orientation: "horizontal"
      range: "min"
      min: 100
      max: 99500
      step: 100
      value: 100
      slide: (event, ui) =>
        @circle.setRadius(100000 - ui.value)
        @map.fitBounds(@circle.getBounds())
        @updateMeasure()
    

    @append @slider, @mapbox, @meters


  createMap: =>
    map = L.map('map',
      center: [51.505, -0.09]
      zoom: 12
      maxZoom: 14
      minZoom: 5
      attributionControl: false
      )

    # Raster tiles
    L.tileLayer(
      'http://{s}.tiles.mapbox.com/v3/mapbox.mapbox-light/{z}/{x}/{y}.png',
        maxZoom: 14
        attributionControl: false
        updateWhenIdle: true
    ).addTo(map)
    # Full screen
    fullScreen = new L.Control.FullScreen()
    map.addControl(fullScreen)

    @circle = L.circle([0,0], 99500,
      fillOpacity: 0.25
      fillColor: "#fff"
      #stroke: false
      weight: 5
      opacity: 0.3
      color: 'black'
      clickable: false
      ).addTo(map)

    map.locate(
      setView: true
      maxZoom: 13
      enableHighAccuracy: true
      )

    map.on('locationfound', (e) =>
      @circle.setLatLng(e.latlng)
      @map.fitBounds(@circle.getBounds())
      )

    map.on('click', (e) =>
      map.panTo(e.latlng)
      @circle.setLatLng(e.latlng)
      )

    map.on('exitFullscreen', (e) =>
      map.fitBounds(@circle.getBounds())
      )

    map.on('viewreset', @updateMeasure)
    map

  updateMeasure: =>
    distance = @circle.getRadius()
    if distance >= 1000
      distance = (Math.round(distance / 100) / 10).toFixed(0)
      unit = "km"
    else
      unit = "m"

    @meters.html "#{distance} #{unit}"
    @meters.show()

module.exports = Map