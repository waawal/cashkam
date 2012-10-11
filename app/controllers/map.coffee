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
    '#categories': 'categories'

  events:
    "click #browse": "search"
    "click #flip": "flipMap"

  constructor: ->
    super
    #@browseButton.html '<button id="browse" class="btn btn-large btn-block btn-success">Browse</button>'

    #@mapFront.html '<div class="front"><div>'
    @mapBack.html '''
    <ul class="nav nav-list" id="nav-list">
      <li class="nav-header">Ad Browser</li>
      <li class="active"><a><i class="icon-globe"></i> Ad Flow</a></li>
      <li><a><i class="icon-search"></i> Search</a></li>
      <li class="nav-header">Me</li>
      <li><a><i class="icon-envelope"></i> Inbox</a></li>
      <li><a><i class="icon-camera"></i> My Ads</a></li>
      <li><a><i class="icon-heart"></i> My Lists</a></li>
      <li class="divider"></li>
      <li><a>Help</a></li>
    </ul>
    '''
    
    @map = new @createMap
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @map.addLayer(marker)
    Spine.bind 'removeMarker', (marker) => @map.removeLayer(marker)
    # # # # #

    #$flipbutton = $('<button id="flip" class="btn btn-mini btn-block">Menu</button>')
    $menuBar = '''
    <div class="navbar" id="navigation-box">
      <div class="navbar-inner" id="main-nav">
          
        <ul class="nav">
          <li id="flip"><a title="Toggle Map/Menu"><i class="icon-list"></i></a></li>
        </ul>
          <!-- <a class="brand" >CashKam</a> --!>
          <button class="btn btn-success btn-mini pull-right" id="browse">Browse</button>
        
      </div>
    </div>
    '''
    @append $menuBar, @mapframe, @categories#, @browseButton
    $("#map-frame").gfxFlip()
    #$('#flip').click (event) =>
    #  @flipMap(event)
      #false


  flipMap: (event) =>
    if $('#flip').hasClass('active')
      $('#flip').removeClass('active')
      @map.setView(@map.getCenter(), @map.getZoom(), true) # Force reset! (ugly, change when upstream offers...)
    else
      $("#flip").addClass("active")
    $("#map-frame").trigger("flip")
    $('#browse').fadeToggle 120
    @categories.fadeToggle 120
    $(event.target).toggleClass("active")
    #$(event.target).addClass "active"  unless $(event.target).hasClass("active")
    event.preventDefault()

  createMap: =>
    map = L.map('map',
      center: [59.712097173322924, 17.9296875]
      zoom: 9
      maxZoom: 14
      minZoom: 3
      attributionControl: false
      zoomControl: false
      #scrollWheelZoom: false
      doubleClickZoom: false
      )
    zoom = new L.Control.Zoom(position: 'bottomright')
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
      position: 'topright'
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
    map.scrollWheelZoom.disable()  unless L.Browser.webkit
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
    #$("html, body").animate {scrollTop: 0}, 40, =>
    @trigger "search" # TODO: Not good at all... first point of optimization ;-)
      #$("#maincontent").empty()
    e.preventDefault()

module.exports = Map