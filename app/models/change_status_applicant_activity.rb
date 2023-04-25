# == Schema Information
#
# Table name: applicant_activities
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  info         :hstore
#  type         :string
#

class ChangeStatusApplicantActivity < ApplicantActivity
  enum rejected_reason: [:superficial_response, :no_experience, :technical_test_failed, :first_interview_failed, :low_english_level, :tecnical_interview_failed, :no_jointly_responsible, :unfinish_course, :no_time]
  enum second_interview_substate: [:pending_second_interview, :scheduled, :unattendance_first_interview, :another_chance]
  enum first_interview_substatus: [:pending_first_interview, :first_interview_scheduled, :unattendance_meeting]
  enum gave_up_reason: [:no_rs, :no_ready_for_test, :no_response, :second_interview_unattendance]

  hstore_accessor :info,
    from_status: :string,
    to_status: :string,
    comment: :string,
    rejected_reason: :string,
    second_interview_substate: :string,
    first_interview_substatus: :string,
    gave_up_reason: :string

  def self.get_substatus_to_human(value)
    mappings = {
      pending: "Pendiente",
      scheduled: "Agendada",
      finished: "Finalizó",
      pending_exercises: "Ejercicios por enviar",
      sent_exercises: "Ejercicios enviados",
      superficial_response: "Respuestas superficiales",
      no_experience: "No tiene la experiencia técnica",
      technical_test_failed: "No pasó prueba técnica",
      first_interview_failed: "No pasó primera entrevista",
      low_english_level: "Inglés muy bajo",
      tecnical_interview_failed: "No pasó entrevista técnica",
      no_jointly_responsible: "No tiene responsable solidario",
      unfinish_course: "No finalizó el curso",
      no_rs: "No encontró responsable solidario",
      no_ready_for_test: "No está listo para la entrevista técnica",
      no_response: "No respondió",
      second_interview_unattendance: "No llegó a segunda entrevista (luego de PUSH, pasa aquí)",
      no_time: "No tiene tiempo para BC",
      unattendance_meeting: "No llegó",
      first_interview_scheduled: "Agendada",
      pending_first_interview: "Pendiente por agendar",
      pending_second_interview: "Pendiente por agendar",
      unattendance_first_interview: "No llegó",
      another_chance: "Otra oportunidad: se hace segunda entrevista o se envían ejercicios",
    }

    value && mappings[value.to_sym]
  end

  def self.substatus(status)
    mappings = {
      rejected: self.rejected_reasons.keys,
      second_interview_held: self.second_interview_substates.keys,
      first_interview_scheduled: self.first_interview_substatuses.keys,
      gave_up: self.gave_up_reasons.keys
    }

    mappings[status.to_sym]
  end

  def self.get_substatus(value)
    mappings = {
      rejected: lambda {|a| self.get_substatus_to_human(a.rejected_reason)},
      second_interview_held: lambda {|a| self.get_substatus_to_human(a.second_interview_substate)},
      first_interview_scheduled: lambda {|a| self.get_substatus_to_human(a.first_interview_substatus)},
      gave_up: lambda {|a| self.get_substatus_to_human(a.gave_up_reason)}

    }

    mappings[value.to_status.to_sym] ? mappings[value.to_status.to_sym][value] : mappings[value.to_status.to_sym]
  end
end
