Spine = require('spine')

class ListItem extends Spine.Controller
  

  className: "preview"


  #events:
  #  "click img": "click"

  # Bind events to the record
  constructor: ->
    super
    throw "@item required" unless @item
    @item.bind("update", @render)
    @item.bind("destroy", @remove)

  # Render an element
  render: (item) =>
    @item = item if item

    @html(@template(@item))
    
    @

  # Use a template, in this case via Eco
  template: (items) ->
    require('views/list')(items)

  # Called after an element is destroyed
  remove: ->
    @el.remove()

  # We have fine control over events, and 
  # easy access to the record too
  click: ->
    alert @item.id
    
module.exports = ListItem