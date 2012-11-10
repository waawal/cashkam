Spine = require('spine')

Map = require('controllers/map')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller

  constructor: ->
    super

    @map = new Map (el: $("#map-holder"))

    #@categories = new Categories(el: $("#categories"))

    #Spine.bind 'global:fetchAds', @queryForAds
    @map.bind "search", @queryForAds # replace with global?
    #@categories.bind "new:ad", @createAd
    @append @map, #@categories



  getData: =>
    #latlng = @map.map.getBounds()
    #q = @categories.searchfield.val()
    #data =
    #  nelat: latlng._northEast['lat']
    #  nelng: latlng._northEast['lng']
    #  swlat: latlng._southWest['lat']
    #  swlng: latlng._southWest['lng']
      #categories: @categories.represent()
      #q: q
    #data
    data =
      lat: Spine.massforstroelse.currentLocation.lat
      lng: Spine.massforstroelse.currentLocation.lng
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
    #Spine.trigger('global:new-search')
    data = @getData()
    Ad.deleteAll() #invalidate :-/
    Ad.fetch(
      processData:true
      data:data
      )
    
module.exports = Ads