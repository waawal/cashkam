Spine = require('spine')

class Categories extends Spine.Controller

  elements:
    "form": "formElement"

  events: 
    "change input[type=checkbox]": "change"

  constructor: ->
    super
    @status = {}
    @el.hide()
    @html require('views/categories')()
    @el.fadeIn(800)

  change: (e) =>
    @status[e.target.id] = e.target.checked
  
  represent: ->
    result = [category for category, status of @status when status]
    unless result
      return "all"
    else
      result.join(',')

module.exports = Categories