class InnovateProgramView extends Backbone.View
  el: '.innovate-program'

  initialize: ->

  events: ->
    "click .apply-now-btn": "show_registration"

  show_registration: (e) ->
    e.preventDefault()
    new InnovateRegistrationView()

class InnovateRegistrationView extends Backbone.View
  el: '#application-modal'

  initialize: ->
    @step = 1
    @render()

  render: ->
    $(@el).on('shown.bs.modal', =>

    ).modal()

  events: ->
    "click .next": "handle_navigation"
    "click .back": "navigate_back"
    "click .finish": "submit_form"

  handle_navigation: (e) ->
    e.preventDefault()

    @['after_step_' + @step]((valid, action) =>
      @.$('.next').attr('disabled', false)

      action() if action
    )

  navigate: (direction) =>
    @.$('.step-' + @step).hide()
    @step = @step + direction

    @.$('.step-' + @step).show()
    @['before_step_' + @step]() # before step callback

    @show_or_hide_buttons()

  navigate_back: (e) =>
    e.preventDefault()
    @navigate(-1)

  show_or_hide_buttons: ->
    if @step > 1 then @.$('.back').show() else @.$('.back').hide()
    if @step == 3
      @.$('.next').hide()
      @.$('.finish').show()
    else
      @.$('.next').show()
      @.$('.finish').hide()

  before_step_1: ->

  after_step_1: (callback) ->
    @.$('.step-1 .form-group, .step-1 .checkbox').removeClass('has-error')

    valid = true
    valid = false if !@checkbox_is_selected($('#terms'))

    if valid
      @navigate(1)
      callback(true)
    else
      callback(false)

  before_step_2: ->
    @.$('#first-name').focus()

  after_step_2: (callback) ->
    @.$('.step-2 .form-group').removeClass('has-error')

    valid = true
    valid = false if !@input_text_is_valid($('#first-name'))
    valid = false if !@input_text_is_valid($('#last-name'))
    valid = false if !@input_text_is_valid($('#email'))
    valid = false if !@input_text_is_valid($('#birthday'))
    valid = false if !@input_text_is_valid($('#gender'))
    valid = false if !@input_text_is_valid($('#mobile'))
    valid = false if !@input_text_is_valid($('#format'))

    @navigate(1) if valid
    callback(valid)

  before_step_3: ->

  submit_form: ->
    @.$('.step-3 .form-group').removeClass('has-error')

    valid = true
    valid = false if !@input_text_is_valid($('#goal'))
    valid = false if !@input_text_is_valid($('#experience'))
    valid = false if !@input_text_is_valid($('#additional'))

    if valid
      @.$('.finish').attr('disabled', true)
      @.$('#application-form')[0].submit()

  input_text_is_valid: (field, message) ->
    if field.val().replace(/\s+/, '').length == 0
      field.closest('.form-group').addClass('has-error')
      return false
    return true

  checkbox_is_selected: (field, message) ->
    if !field.is(':checked')
      field.closest('.checkbox').addClass('has-error')
      return false
    return true

window.InnovateProgramView = InnovateProgramView
