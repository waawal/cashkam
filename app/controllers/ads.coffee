Spine = require('spine')
require('lib/jquery-ui')
Map = require('controllers/map')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller

  constructor: ->
    super

    @map = new Map (el: $("#map-holder"))

    @categories = new Categories(el: $("#categories"))
    @map.bind "search", @queryForAds
    @map.bind "initialLocation", @queryForAds
    @categories.bind "new:ad", @createAd
    @append @map, @categories


  getData: =>
    #latlng = @map.circle.getLatLng()
    #radius = @map.circle.getRadius()
    latlng = @map.map.getBounds()
    @log latlng
    q = @categories.searchfield.val()
    data =
      nelat: latlng.northEast['lat']
      nelng: latlng.northEast['lng']
      swlat: latlng.southWest['lat']
      swlng: latlng.southWest['lng']
      #neLat: boundingBox['_northEast']['lat']
      #neLng: boundingBox['_northEast']['lng']
      #swLat: boundingBox['_southWest']['lat']
      #swLng: boundingBox['_southWest']['lng']
      categories: @categories.represent()
      q: q
    data


  createAd: =>
    data = @getData()
    Ad.create(
      media: "http://www.gadgetreview.com/wp-content/uploads/2008/09/dripping-table.jpg"
      text: data.q
      lat: data.lat
      lng: data.lng
      )


  queryForAds: =>
    data = @getData()
    Ad.deleteAll() #invalidate :-/
    Ad.fetch(
      processData:true
      data:data
      )


    
module.exports = Ads