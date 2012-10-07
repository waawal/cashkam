(->
  $ = jQuery
  defaults =
    width: 240
    height: 240

  $.fn.gfxFlip = (options) ->
    options = {}  unless options?
    opts = $.extend({}, defaults, options)
    front = $(this).find(".front")
    back = $(this).find(".back")

    getHeight = ($el) ->
      console.log $el.find('img').height()
      $el.find('img').height() + 100

    $(this).css
      position: "relative"
      "-webkit-perspective": "600"
      "-moz-perspective": "600"
      "-webkit-transform-style": "preserve-3d"
      "-moz-transform-style": "preserve-3d"
      "-webkit-transform-origin": "50% 50%"
      "-moz-transform-origin": "50% 50%"
      #width: opts.width
      width: opts.width
      height: 240#getHeight(front)

    front.add(back).css
      position: "absolute"
      width: "100%"
      height: "100%"
      display: "block"
      "-webkit-backface-visibility": "hidden"
      "-moz-backface-visibility": "hidden"

    back.transform rotateY: "-180deg"
    $(this).bind "flip", ->
      $(this).toggleClass "flipped"
      flipped = $(this).hasClass("flipped")
      front.gfx rotateY: (if flipped then "180deg" else "0deg")
      back.gfx rotateY: (if flipped then "0deg" else "-180deg")

).call this