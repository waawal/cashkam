Spine = require('spine')
$ = Spine.$

class Navigations extends Spine.Controller

  events:
    #"mouseenter": "fadeIn"
    #"mouseleave": "fadeOut"
    "click #flip": "flip"

  constructor: ->
    super
    @html  '''
    <div class="navbar navbar-fixed-top nav-pills" id="navigation-box">
      <div class="navbar-inner" id="main-nav">
          
        <ul class="nav">
          <li id="flip"><a title="Toggle Map/Menu"><i class="icon-list"></i></a></li>
          <li><a title="Toggle Map/Menu"><i class="icon-th"></i></a></li>
        </ul>

      </div>
    </div>
    '''

  fadeOut: =>
    @el.css('opacity', '0.3')
  fadeIn: =>
    @el.css('opacity', '1.0')



  flip: (event) => Spine.trigger("global:flip", event)

module.exports = Navigations