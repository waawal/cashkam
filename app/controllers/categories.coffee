Spine = require('spine')

class Categories extends Spine.Controller

  @extend(Spine.Events)


  elements:
    "form": "formElement"
    'input[type=search]': 'searchfield'


  events: 
    "change input[type=checkbox]": "change"
    
    "click #create": "createAd"
    "click #show-categories": (e) => $("form").slideToggle("slow")


  constructor: ->
    super
    @status = {}
    @html require('views/categories')()
    $("form").hide()


  change: (e) =>
    @status[e.target.id] = e.target.checked
  

  represent: ->
    result = [category for category, status of @status when status]
    unless result
      return "all"
    else
      result.join(',')

  createAd: (e) =>
    e.preventDefault()
    @trigger "new:ad"


module.exports = Categories