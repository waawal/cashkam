Spine = require('spine')

# Remove later
Spine.Model.host = "http://emea-fr-01.services.massforstroel.se"

class Ad extends Spine.Model
  @configure 'Ad', 'username', 'media', 'text', 'category', 'lat', 'lng'

  @extend Spine.Model.Ajax
  

module.exports = Ad