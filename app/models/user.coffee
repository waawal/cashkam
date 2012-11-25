Spine = require('spine')
$ = Spine.$

class User extends Spine.Model
  @configure 'User', 'name', 'email', 'ads'
  @extend Spine.Model.Ajax

  #constructor: ->
  #  super
  #  @fetch()

  @fetch: (params) ->
    if params
      super
        processData:true
        data: params
        xhrFields:
          withCredentials: true
    else
      super
        xhrFields:
          withCredentials: true
  # Events # # #
  @bind "ajaxError", (record, xhr, settings, error) =>
      console.log a for a in [record, xhr, settings, error]
      if xhr.status is 401 or xhr.status is 403
        Spine.massforstroelse.loggedIn = false
        Spine.trigger "global:loggedOut"
        Spine.trigger "global:logIn"
      # Invalid response...
  @bind "ajaxSuccess", (status, xhr) =>
    unless Spine.massforstroelse.loggedIn and @all()
      Spine.massforstroelse.loggedIn = true
      Spine.trigger "global:loggedIn"

  @login = (email, password) =>
    @fetch({username: email, password: password})

  @createNewUser = (username, email, password) =>
    data = {username: username, email: email, password: password}
    url = @url()
    $.post url,
      data: data
      processData: true
      xhrFields:
          withCredentials: true

module.exports = User