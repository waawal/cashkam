Spine = require('spine')
L = require ('lib/leaflet')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller


  elements:
    '#map': 'mapbox'
    '#meters': 'meters'
    #'#categories': 'categories'


  constructor: ->
    super
    
    @meters.hide()
    @meters.html "Distance"

    @map = L.map('map',
      center: [51.505, -0.09]
      zoom: 12
      maxZoom: 14
      minZoom: 5
      attributionControl: false
      )

    @setupMap()
    #@mapbox.hide()
    
    @categories = new Categories(el: $("#categories"))
    @append @mapbox, @meters, @categories
    #@mapbox.fadeIn(1600)
    #@delay(@updateMeasure,1000) # sleep before initial - on.'load' malfunctions.

  setupMap: =>
    # Raster tiles
    L.tileLayer(
      'http://{s}.tiles.mapbox.com/v3/mapbox.mapbox-light/{z}/{x}/{y}.png',
        maxZoom: 18
        attributionControl: false
        updateWhenIdle: true
    ).addTo(@map)
    # Full screen
    #fullScreen = new L.Control.FullScreen()
    #@map.addControl(fullScreen)

    @circle = L.circle([0,0], 1000,
      fillOpacity: 0.25
      fillColor: "#fff"
      #stroke: false
      weight: 5
      opacity: 0.3
      color: 'black'
      clickable: false
      ).addTo(@map)

    @map.locate(
      setView: true
      maxZoom: 13
      enableHighAccuracy: true
      )
    @map.on('locationfound', (e) =>
      @circle.setLatLng(e.latlng)
      )


    @map.on('click', (e) =>
      @map.panTo(e.latlng)
      @circle.setLatLng(e.latlng)
      )

    

    # temp
    #@map.on('click', (e) =>
    #  boundingBox = @map.getBounds()
    #  @queryForAds(e, boundingBox)
    #  )

    @map.on('viewreset', @updateMeasure)

  updateMeasure: =>
    
    distance = @circle.getRadius()
    if distance >= 1000
      distance = (Math.round(distance / 100) / 10).toFixed(0)
      unit = "km"
    else
      unit = "m"

    #Spine.$(@meters).slideUp(60)
    @meters.html "#{distance} #{unit}"
    @meters.show()
    #Spine.$(@meters).slideDown(180)


  queryForAds: (e, boundingBox) =>
    data =
      lat: e['latlng']['lat']
      lng: e['latlng']['lng']
      neLat: boundingBox['_northEast']['lat']
      neLng: boundingBox['_northEast']['lng']
      swLat: boundingBox['_southWest']['lat']
      swLng: boundingBox['_southWest']['lng']
      categories: @categories.represent()

    

    Ad.fetch(
      processData:true
      data:data
      )
      

    #@append @map
    #

    
module.exports = Ads