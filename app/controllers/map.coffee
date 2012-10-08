Spine = require('spine')
L = require ('lib/leaflet')

require('lib/jquery-ui')
require 'lib/gfx'
require 'lib/gfx.flip'

class Map extends Spine.Controller
  #className: "side-map"
  elements:
    '#map': 'mapbox'
    '#browse-button': 'browseButton'
    '#map-frame': 'mapframe'
    '#map-front': 'mapFront'
    '#map-back': 'mapBack'

  events:
    "click #browse": "search"
    "click #flip": "flipMap"

  constructor: ->
    super
    @browseButton.html '<button id="browse" class="btn btn-large btn-block">Browse</button>'

    btnGroup = '''
    <div class="btn-group row-fluid">
      <button class="btn btn-large" id="browse">Browse</button>
      <button class="btn btn-large dropdown-toggle" data-toggle="dropdown">
        <span class="caret"></span>
      </button>
      <ul class="dropdown-menu">
        <!-- dropdown menu links -->
          <li id="flip"><a href="#">Saved Searches</a></li>
      </ul>
    </div>
    '''
    #@mapFront.html '<div class="front"><div>'
    @mapBack.html '''
    <ul class="nav nav-list">
      <li class="nav-header">Ad Browser</li>
      <li><a href="#">Ad Flow</a></li>
      <li class="active"><a href="#">Detailed Search</a></li>
      <li class="nav-header">Me</li>
      <li><a href="#">My Ads</a></li>
      <li><a href="#">My Saved searches</a></li>
      <li><a href="#">Stream</a></li>
      <li class="divider"></li>
      <li><a href="#">Help</a></li>
    </ul>
    '''
    #'<div class="back"><div>'
    
    @map = new @createMap
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @map.addLayer(marker)
    Spine.bind 'removeMarker', (marker) => @map.removeLayer(marker)
    # # # # #
    '''
    <ul class="nav nav-tabs">
      <li class="active"><a href="#">Home</a></li>
      <li><a href="#">Help</a></li>
      <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Dropdown <b class="caret"></b></a>
        <ul class="dropdown-menu">
          <li><a href="#">Action</a></li>
          <li><a href="#">Another action</a></li>
          <li><a href="#">Something else here</a></li>
          <li class="divider"></li>
          <li><a href="#">Separated link</a></li>
        </ul>
      </li>
    </ul>
    '''
    $flipbutton = $('<button id="flip" class="btn btn-mini btn-block">Menu</button>')
    @append $flipbutton, @mapframe, @browseButton
    $("#map-frame").gfxFlip()

  flipMap: =>
    if $('#flip').hasClass('active')
      $('#flip').removeClass('active')
    else
      $("#flip").addClass("active")
    $("#map-frame").trigger("flip")
    $('#browse').slideToggle(120)
    @map.invalidateSize(false)

  createMap: =>
    map = L.map('map',
      center: [59.712097173322924, 17.9296875]
      zoom: 9
      maxZoom: 14
      minZoom: 3
      attributionControl: false
      zoomControl: false
      scrollWheelZoom: false
      doubleClickZoom: false
      )
    zoom = new L.Control.Zoom(position: 'topleft')
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
      maxWidth: 160
      position: 'bottomright'
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
    
    #map.on('click', (e) =>
    #  map.panTo(e.latlng)
    #  )
    map


  initialLocation: (latlng) =>
    @map.panTo(latlng)
    @location = latlng
    @map.meMarker = new L.marker(@location,
      icon: @map.meicon
      clickable: true
      title: "You!"
      draggable: true
      )
    @map.meMarker.on 'dragend', (e) => Spine.trigger("global:position-changed", e)
    @map.meMarker.addTo(@map)
    @trigger "search"


  search: (e) =>
    e.preventDefault()
    @trigger "search"


module.exports = Map