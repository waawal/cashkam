Spine = require('spine')

# Remove later
Spine.Model.host = "http://api.cashkam.alpha.massforstroel.se"

class Ad extends Spine.Model
  @configure 'Ad', 'username', 'media', 'text', 'category', 'lat', 'lng'

  @extend Spine.Model.Ajax
  

module.exports = Ad