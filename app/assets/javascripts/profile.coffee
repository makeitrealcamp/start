class ProfileView extends Backbone.View

  events:
    "change .update-profile-visibility input": "update_profile_visibility"

  update_profile_visibility: ->
    @$(".update-profile-visibility").submit()


window.ProfileView = ProfileView
