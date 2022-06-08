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
  enum rejected_reason: [:superficial_response, :no_experience, :technical_test_failed, :first_interview_failed, :low_english_level, :tecnical_interview_failed, :no_jointly_responsible]
  enum second_interview_substate: [:pending, :scheduled, :finished, :pending_exercises, :sent_exercises]

  hstore_accessor :info,
    from_status: :string,
    to_status: :string,
    comment: :string,
    rejected_reason: :string,
    second_interview_substate: :string

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
      no_jointly_responsible: "No tiene responsable solidario"
    }

    mappings[value.to_sym]
  end

  def self.substatus(status)
    mappings = {
      rejected: self.rejected_reasons.keys,
      second_interview_held: self.second_interview_substates.keys
    }

    mappings[status.to_sym]
  end

  def self.get_substatus(value)
    mappings = {
      rejected: lambda {|a| self.get_substatus_to_human(a.rejected_reason ? a.rejected_reason : a)},
      second_interview_held: lambda {|a| self.get_substatus_to_human(a.second_interview_substate ?  a.second_interview_substate : a)}
    }

   mappings[value.to_status.to_sym] ? mappings[value.to_status.to_sym][value] : mappings[value.to_status.to_sym]
  end
end
