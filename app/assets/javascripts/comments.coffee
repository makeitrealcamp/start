$ ->
  $('.response .add-form-response').on 'click', (e) ->
    if $(this).parents('.sections-comments').find('.form-aswer').length > 0
      return false
    return

  $(document).on 'click', '.cancel-button', (e) ->
    e.preventDefault()
    $(this).parents('.form-aswer').remove()
    return
  return
