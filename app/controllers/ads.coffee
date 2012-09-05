Spine = require('spine')

Map = require('controllers/map')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller


  #elements:
  #  '#categories': 'categories'


  constructor: ->
    super
    
    
    @map = new Map (el: $("#map-holder"))
    
    @categories = new Categories(el: $("#categories"))
    @append @map, @categories
    #@mapbox.fadeIn(1600)
    #@delay(@updateMeasure,1000) # sleep before initial - on.'load' malfunctions.

  


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