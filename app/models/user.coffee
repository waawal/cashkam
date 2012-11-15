Spine = require('spine')

class User extends Spine.Model
  @configure 'User', 'name', 'likes', 'ads'
  @extend Spine.Model.Ajax
  @bind "ajaxError", (record, xhr, settings, error) ->
    if xhr.status is 403
      Spine.massforstroelse.loggedIn = false
      Spine.trigger "global:logIn"
  # Invalid response...
  @bind "ajaxSuccess", (status, xhr) ->
    unless Spine.massforstroelse.loggedIn
      Spine.massforstroelse.loggedIn = true
      Spine.trigger "global:loggedIn"
  @fetch: (params) ->
    data = {email: params.email, password: params.password}
    super(processData:true, data: data)

module.exports = User