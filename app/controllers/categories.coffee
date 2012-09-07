Spine = require('spine')

class Categories extends Spine.Controller

  @extend(Spine.Events)


  elements:
    "form": "formElement"


  events: 
    "change input[type=checkbox]": "change"
    "click #browse": "search"
    "click #create": "create"


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


  search: (e) =>
    e.preventDefault()
    @trigger "search"

  create: (e) =>
    e.preventDefault()
    @trigger "new"


module.exports = Categories