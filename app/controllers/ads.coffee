Spine = require('spine')

Map = require('controllers/map')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller

  constructor: ->
    super

    @map = new Map (el: $("#map-holder"))

    @categories = new Categories(el: $("#categories"))
    @categories.bind "search", @queryForAds
    @append @map, @categories


  queryForAds: =>
    latlng = @map.circle.getLatLng()
    radius = @map.circle.getRadius()

    data =
      lat: latlng['lat']
      lng: latlng['lng']
      radius: radius
      #neLat: boundingBox['_northEast']['lat']
      #neLng: boundingBox['_northEast']['lng']
      #swLat: boundingBox['_southWest']['lat']
      #swLng: boundingBox['_southWest']['lng']
      categories: @categories.represent()

    Ad.fetch(
      processData:true
      data:data
      )

    
module.exports = Ads