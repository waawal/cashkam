Spine = require('spine')

class Category extends Spine.Model
  @configure 'Category', 'name', 'show'
  @extend Spine.Model.Local

  constructor: ->
    super

  represent: ->
    @select (category) -> category.first_name

module.exports = Category