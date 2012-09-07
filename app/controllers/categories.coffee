Spine = require('spine')

class Categories extends Spine.Controller

  @extend(Spine.Events)


  elements:
    "form": "formElement"
    'input[type=search]': 'searchfield'


  events: 
    "change input[type=checkbox]": "change"
    "click #browse": "search"
    


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

  


module.exports = Categories