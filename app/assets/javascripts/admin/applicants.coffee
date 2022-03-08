class SendEmailView
  constructor: (options) ->
    @templates = options.templates || []

    $("#email_template").change(@handle_change_template)

  handle_change_template: =>
    template_id = $("#email_template").val()

    if template_id
      template = @templates.find((element) -> parseInt(template_id, 10) == element.id);

      $("#email_applicant_activity_subject").val(template.subject)
      $("#email_applicant_activity_body").val(template.body)

      $('.fields').show()
    else
      $("#email_applicant_activity_subject").val("")
      $("#email_applicant_activity_body").val("")

      $('.fields').hide()

window.SendEmailView = SendEmailView

class onChancheRejectReason
  constructor: () ->
    $("#status_selection").change(@handle_change_reason)

  handle_change_reason: =>
    status = $("#status_selection").val()
    
    if status == 'rejected'
      $('#reject_reason_group').show()
      $('#reject_reason_select').prop( "disabled", false );
    else
      $('#reject_reason_group').hide()
      $('#reject_reason_select').prop( "disabled", true );

window.onChancheRejectReason = onChancheRejectReason