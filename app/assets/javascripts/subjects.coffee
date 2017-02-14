class ProfileQuestionsView extends Backbone.View
  el: '#questions-modal'

  initialize: ->
    @part = 1
    @render()

  render: ->
    $(@el).on('bs.modal.shown', ->
      @.$('#card-number').payment('formatCardNumber')
      @.$('#card-cvv').payment('formatCardCVC')
      @.$('#card-exp').payment('formatCardExpiry')
    ).modal(backdrop: 'static')

  events:
    "click .next": "navigate_next"
    "click .back": "navigate_back"
    "submit form": "validate"

  navigate_next: (e) ->
    e.preventDefault()
    @navigate(1) if @validate()

  navigate_back: (e) ->
    e.preventDefault()
    @.$('.option-alert').hide()
    @navigate(-1)

  navigate: (direction) ->
    @.$('.part-' + @part).hide()
    @part = @part + direction
    @.$('.part-' + @part).show()
    @show_or_hide_buttons()

  validate: ->
    @.$('#questions-modal .form-group').removeClass('has-error')
    @.$('.option-alert').hide()
    if @part == 1
      @input_text_is_valid(@.$('#user_first_name'))
    else
      @at_least_one_radio()

  input_text_is_valid: (field) ->
    if field.val().replace(/\s+/, '').length == 0
      field.closest('.form-group').addClass('has-error')
      return false
    return true

  at_least_one_radio: ->
    if $('.part-' + @part + ' input[type=radio]:checked').size() == 0
      @.$('.option-alert').show()
      return false
    return true

  show_or_hide_buttons: ->
    if @part > 1 then @.$('.back').show() else @.$('.back').hide()
    if @part == 4
      @.$('.next').hide()
      @.$('.finish').show()
    else
      @.$('.next').show()
      @.$('.finish').hide()

window.ProfileQuestionsView = ProfileQuestionsView
