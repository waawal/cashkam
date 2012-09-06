Spine = require('spine')

# Remove later
Spine.Model.host = "http://localhost:8080"

class Ad extends Spine.Model
  @configure 'Ad', 'username', 'media', 'text', 'category', 'lat', 'lng'

  @extend Spine.Model.Ajax
  

module.exports = Ad