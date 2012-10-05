Spine = require('spine')

# Remove later
Spine.Model.host = "http://api.cashkam.alpha.massforstroel.se:8383"

class Ad extends Spine.Model
  @configure 'Ad', 'username', 'media', 'text', 'category', 'lat', 'lng'

  @extend Spine.Model.Ajax
  

module.exports = Ad