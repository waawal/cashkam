Spine = require('spine')

class User extends Spine.Model
  @configure 'User', 'name', 'likes', 'ads'
  @extend Spine.Model.Ajax
  @fetch: (params) ->
    data = {email: params.email, password: params.password}
    super(processData:true, data: data)

  @bind "ajaxError", (record, xhr, settings, error) =>
      #status is 0 if 403 sent over CORS :-/
      Spine.massforstroelse.loggedIn = false
      Spine.trigger "global:logIn"
      # Invalid response...
  @bind "ajaxSuccess", (status, xhr) =>
    unless Spine.massforstroelse.loggedIn
      Spine.massforstroelse.loggedIn = true
      Spine.trigger "global:loggedIn"

module.exports = User