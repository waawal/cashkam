Spine = require('spine')
L = require ('lib/leaflet')
Navigations = require ('controllers/navigations')

require('lib/jquery-ui')
require 'lib/gfx'
require 'lib/gfx.flip'
require 'lib/easing'

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
    #"click #flip": "flipMap"

  constructor: ->
    super
    @browseButton.html '<button id="browse" class="btn btn-large btn-block btn-success">Browse</button>'

    #@mapFront.html '<div class="front"><div>'
    @mapBack.html '''
    <ul class="nav nav-list" id="nav-list">
      <li class="nav-header">Ad Browser</li>
      <li class="active"><a><i class="icon-globe"></i> Nearby</a></li>
      <li><a><i class="icon-search"></i> Search</a></li>
      <li class="nav-header">Me</li>
      <li><a><i class="icon-inbox"></i> Inbox</a></li>
      <li><a><i class="icon-camera"></i> My Ads</a></li>
      <li><a><i class="icon-heart"></i> My Lists</a></li>
      <li class="divider"></li>
      <li><a><i class="icon-book"></i> Help</a></li>
    </ul>
    '''
    
    @map = new @createMap
    @menuBar = new Navigations
    
    # # # # #
    # Global Events attached to Spine :-( Coming from listitem controller
    Spine.bind 'showMarker', (marker) => @checkIfFetching(marker, "show")
    Spine.bind 'removeMarker', (marker) => @checkIfFetching(marker, "hide")
    Spine.bind 'global:flip', (event) => @flipMap(event)
    # # # # #

    @categories.hide() # Fix this soon ******
    @append @mapframe, @browseButton, @menuBar, @categories#, @browseButton
    $("#map-frame").gfxFlip()
    @fetching = false
    #$('#flip').click (event) =>
    #  @flipMap(event)
      #false

  checkIfFetching: (marker, action="show") => # is this working???
    unless @fetching
      if action is "show"
        #@oldCenter = @map.getCenter()
        #@oldZoomLevel = @map.getZoom()
        #@log Spine.massforstroelse.currentLocation, marker.getLatLng()
        @map.markersLayer.clearLayers()
        bounds =  new L.LatLngBounds(Spine.massforstroelse.currentLocation, marker.getLatLng())
        #bounds.pad(10000)
        @map.fitBounds(bounds)
        #@map.on "moveend", =>
        @map.markersLayer.addLayer(marker)
          #@map.off("moveend") # Warning - removes all moveend listeners
      else
        #@map.setView(@oldCenter, @oldZoomLevel)

        #@map.markersLayer.removeLayer(marker) TODO: check why it doesnt work after implementing moveend
        @map.markersLayer.clearLayers()

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
    
    map.markersLayer = L.layerGroup()
    map.markersLayer.addTo(map)
    #map.on('click', (e) =>
    #  map.panTo(e.latlng)
    #  )
    map.scrollWheelZoom.disable()  unless L.Browser.webkit
    map


  initialLocation: (latlng) => # Should handle errors if location not allowed !!!!!
    Spine.massforstroelse.currentLocation = latlng
    @map.panTo(latlng)
    @location = latlng
    @map.meMarker = new L.marker(@location,
      icon: @map.meicon
      clickable: true
      title: "You!"
      draggable: true
      )
    @map.meMarker.on 'dragend', (e) =>
      Spine.trigger("global:position-changed", e)
      Spine.massforstroelse.currentLocation = e.target.dragging._marker._latlng
    @map.meMarker.addTo(@map)
    @trigger "search"


  search: (e) =>
    @fetching = true
    $("#maincontent").fadeToggle(600, 'easeOutQuart')
    $("html, body").animate scrollTop: 0, 600, 'easeInOutCubic', =>
      $("#maincontent").empty()
      @trigger "search" # TODO: Not good at all... first point of optimization ;-)
      $("#maincontent").fadeIn(400, 'easeInOutQuint', =>
        @fetching = false
        @map.markersLayer.clearLayers()
        )
    #$("#maincontent").empty()
    e.preventDefault()
    #@fetching = false

module.exports = Map