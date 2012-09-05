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
    
    @meters.html "Distance"

    @map = L.map('map',
      center: [51.505, -0.09]
      zoom: 12
      maxZoom: 15
      minZoom: 5
      attributionControl: false
      )

    @setupMap()

    @categories = new Categories(el: $("#categories"))
    @append @mapbox, @meters, @categories
    @delay(@updateMeasure,1000) # sleep before initial - on.'load' malfunctions.

  setupMap: =>
    # Raster tiles
    L.tileLayer(
      'http://{s}.tiles.mapbox.com/v3/mapbox.mapbox-light/{z}/{x}/{y}.png',
        maxZoom: 18
        attributionControl: false
    ).addTo(@map)
    # Full screen
    fullScreen = new L.Control.FullScreen()
    @map.addControl(fullScreen)

    @map.locate(
      setView: true
      maxZoom: 13
      enableHighAccuracy: true
      )


    # temp
    @map.on('click', (e) =>
      boundingBox = @map.getBounds()
      @queryForAds(e, boundingBox)
      )

    @map.on('viewreset', @updateMeasure)

  updateMeasure: =>
    bBox = @map.getBounds()
    distance = Math.round(bBox['_southWest'].distanceTo(bBox['_northEast'])/100)*100
    if distance >= 1000
      distance = (Math.round(distance / 100) / 10).toFixed(0)
      unit = "km"
    else
      unit = "m"

    #Spine.$(@meters).slideUp(60)
    @meters.html "#{distance} #{unit}"
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