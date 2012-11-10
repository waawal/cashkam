Spine = require('spine')
$ = Spine.$

class Navigations extends Spine.Controller

  events:
    #"mouseenter": "fadeIn"
    #"mouseleave": "fadeOut"
    "click #flip": "flip"
    "click #top-messages": "showLoginModal"

  constructor: ->
    super
    @html  '''
    <div class="navbar navbar-fixed-top nav-pills" id="navigation-box">
      <div class="navbar-inner" id="main-nav">
          
        <ul class="nav">
          <li id="flip"><a title="Toggle Map/Menu"><i class="icon-list"></i> Menu</a></li>
          <li><a title="Toggle Map/Menu"><i class="icon-th"></i> Map</a></li>
          <li id="fat-menu" class="dropdown">
            <a id="drop3" role="button" class="dropdown-toggle" data-toggle="dropdown" title="Settings"><i class="icon-wrench"></i> Settings <span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="drop3">
              <li><a tabindex="-1">Notifications</a></li>
            </ul>
        </ul>

        <ul class="nav pull-right">
          <li><a title="Messages" id="top-messages">Inbox <span class="badge badge-important">6</span></a></li>

          <li class="divider-vertical"></li>

          <li id="fat-menu" class="dropdown">
            <a id="drop3" role="button" class="dropdown-toggle" data-toggle="dropdown" title="Settings"><i class="icon-user"></i> Username <span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="drop3">
              <li><a tabindex="-1">My Ads</a></li>
              <li><a tabindex="-1">My Lists</a></li>
              <li><a tabindex="-1">Information</a></li>
              <li class="divider"></li>
              <li><a tabindex="-1">Log Out</a></li>
            </ul>
        </ul>
      </div>
    </div>
    '''

  fadeOut: =>
    @el.css('opacity', '0.3')
  fadeIn: =>
    @el.css('opacity', '1.0')

  showLoginModal: =>
    $('#myModal').modal('toggle')

  flip: (event) => Spine.trigger("global:flip", event)

module.exports = Navigations