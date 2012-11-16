Spine = require('spine')
User = require 'models/user'
$ = Spine.$
require('spine/lib/route')
Manager = require('spine/lib/manager')
require 'lib/blur'

$navBar = $('''
<div class="navbar navbar-fixed-top nav-pills" id="navigation-box">
  <div class="navbar-inner" id="main-nav">
      
    <ul class="nav">
      <li id="flip"><a title="Toggle Map/Menu"><i class="icon-list"></i> Menu</a></li>
    </ul>

    <ul class="nav pull-right" id="user-menu">
      
    </ul>
  </div>
</div>
''')
$loginForm = $('''
<form class="navbar-form pull-left" id="login-form">
  <input type="text" class="span2" placeholder="Email" id="login-email">
  <input type="password" class="span2" placeholder="Password" id="login-password">
  <button type="submit" class="btn">Sign in</button>
</form>
''')

#<form class="form-inline">
#  <input type="text" class="input-small" placeholder="Email">
#  <input type="password" class="input-small" placeholder="Password">
#  <label class="checkbox">
#    <input type="checkbox"> Remember me
#  </label>
#  <button type="submit" class="btn">Sign in</button>
#</form>

$loginModal = $("""
<!-- Modal -->
<div class="modal hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Log in</h3>
  </div>
  <div class="modal-body">
    
    <form class="form-horizontal">
      <div class="control-group">
        <label class="control-label" for="inputEmail">Email</label>
        <div class="controls">
          <input type="text" id="inputEmail" placeholder="Email">
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="inputPassword">Password</label>
        <div class="controls">
          <input type="password" id="inputPassword" placeholder="Password">
        </div>
      </div>
      <div class="control-group">
        <div class="controls">
          <label class="checkbox">
            <input type="checkbox"> Remember me
          </label>
        </div>
      </div>
    

  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" type="submit">Log in</button>

  </form>
  </div>
</div>
""")

class Navigations extends Spine.Controller

  elements:
    '#user-menu': 'userMenu'
    '#no-of-messages': 'messages'
    '#username': 'username'
    '#my-ads': 'myAds'
    '#my-lists': 'myLists'
    '#user-information': 'userInformation'
    '#logout': 'logoutButton'
    '#login': 'loginButton'
    '#login-email': 'loginEmail'
    '#login-password': 'loginPassword'



  events:
    #"mouseenter": "fadeIn"
    #"mouseleave": "fadeOut"
    "click #flip": "flip"
    "click #top-messages": "showLoginModal"
    "click #logout": "logOut"
    "click #login": "logIn"
    "submit form": "fetchUser"

  constructor: ->
    super
    User.fetch()

    @html $navBar
    
    $('#login-form').submit (e) => @fetchUser(e)
    @loggedOut()
    @loginModal = $($loginModal).modal backdrop: false, show: false
    @loginModal.on 'show', =>
      $('#contentwrapper').blurjs
        radius: 5
        persist: true
      $('#sidebar').blurjs
        radius: 2
        persist: true
     #$('#footer-controls').fadeToggle('slow')
    @loginModal.on 'hidden', =>
      $.blurjs 'reset'


    # Global events
    Spine.bind 'global:loggedIn', =>
      @loggedIn()
    Spine.bind 'global:loggedOut', =>
      @loggedOut()

  loggedIn: =>
    @userMenu.empty()
    @userMenu.append """
    <li><a title="Messages" id="top-messages">Inbox <span class="badge badge-important" id="no-of-messages">6</span></a></li>

          <li class="divider-vertical"></li>

          <li id="fat-menu" class="dropdown">
            <a id="drop3" role="button" class="dropdown-toggle" data-toggle="dropdown" title="Settings"><i class="icon-user"></i> <span id="username">malbaho </span><span class="caret"></span></a>
            <ul class="dropdown-menu" role="menu" aria-labelledby="drop3">
              <li id="my-ads"><a tabindex="-1">My Ads</a></li>
              <li id="my-lists"><a tabindex="-1">My Lists</a></li>
              <li id="user-information"><a tabindex="-1">Information</a></li>
              <li class="divider"></li>
              <li id="logout"><a tabindex="-1">Log Out</a></li>
            </ul>
    """
    user = User.first()
    @username.html user.email
  loggedOut: =>
    @userMenu.empty()
    @userMenu.append $loginForm
    @userMenu.append '<li id="login"><a title="Log in"><i class="icon-user"></i> Log in</a></li>'

  logIn: =>
    Spine.trigger 'global:loggedIn'
  logOut: =>
    Spine.trigger 'global:loggedOut'

  fetchUser: (e) ->
    User.login $('#login-email').val(), $('#login-password').val()

  fadeOut: =>
    @el.css('opacity', '0.3')
  fadeIn: =>
    @el.css('opacity', '0.9')

  showLoginModal: =>
    @loginModal.modal('toggle')

  flip: (event) => Spine.trigger("global:flip", event)

module.exports = Navigations