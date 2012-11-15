Spine = require('spine')

Map = require('controllers/map')
Ad = require 'models/ad'
Categories = require 'controllers/categories'

class Ads extends Spine.Controller

  constructor: ->
    super

    @map = new Map (el: $("#map-holder"))

    #@categories = new Categories(el: $("#categories"))

    Spine.bind 'global:fetchAds', @queryForMoreAds # from waypoints
    @map.bind "search", @queryForAds # replace with global?
    #@categories.bind "new:ad", @createAd
    @append @map, #@categories



  getData: ->
    index = Ad.count()
    data =
      lat: Spine.massforstroelse.currentLocation.lat
      lng: Spine.massforstroelse.currentLocation.lng
      i: index
    data


  createAd: =>
    data = @getData()
    Ad.create(
      media: "http://www.gadgetreview.com/wp-content/uploads/2008/09/dripping-table.jpg"
      text: data.q
      lat: data.lat
      lng: data.lng
      )


  queryForAds:  =>
    if Spine.massforstroelse.currentLocation
      Ad.deleteAll()
      data = @getData()
      Ad.fetch(
        processData:true
        data:data
        xhrFields:
          withCredentials: true
        )

  queryForMoreAds: =>
    if Spine.massforstroelse.currentLocation
      data = @getData()
      Ad.fetch(
        processData:true
        data:data
        xhrFields:
          withCredentials: true
        )


module.exports = Ads