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

class ChangeRejectReasonView
  constructor: () ->
    $("#change_status_applicant_activity_to_status").change(@handle_change_reason)

  handle_change_reason: =>
    status = $("#change_status_applicant_activity_to_status").val()
    
    if status == 'rejected'
      $('#rejected_reason_group').show()
      $('#change_status_applicant_activity_rejected_reason').prop( "disabled", false );
    else
      $('#rejected_reason_group').hide()
      $('#change_status_applicant_activity_rejected_reason').prop( "disabled", true );

window.ChangeRejectReasonView = ChangeRejectReasonView

class ChangeSecondInterviewSubstateView
  constructor: () ->
    $("#change_status_applicant_activity_to_status").change(@handle_change_reason)

  handle_change_reason: =>
    status = $("#change_status_applicant_activity_to_status").val()
    
    if status == 'second_interview_held'
      $('#second_interview_substate_group').show()
      $('#change_status_applicant_activity_second_interview_substate').prop( "disabled", false );
    else
      $('#second_interview_substate_group').hide()
      $('#change_status_applicant_activity_second_interview_substate').prop( "disabled", true );

window.ChangeSecondInterviewSubstateView = ChangeSecondInterviewSubstateView