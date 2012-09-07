Spine = require('spine')

# Remove later
Spine.Model.host = "http://192.168.0.224:8080"

class Ad extends Spine.Model
  @configure 'Ad', 'username', 'media', 'text', 'category', 'lat', 'lng'

  @extend Spine.Model.Ajax
  

module.exports = Ad