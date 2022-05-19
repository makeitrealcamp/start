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

  def self.rejected_reason_to_human(rejected_reason)
    mappings = {
      superficial_response: "Respuestas superficiales",
      no_experience: "No tiene la experiencia técnica (primer acercamiento a la programación)",
      technical_test_failed: "No pasó prueba técnica",
      first_interview_failed: "No pasó primera entrevista",
      low_english_level: "Inglés muy bajo",
      tecnical_interview_failed: "No pasó entrevista técnica",
      no_jointly_responsible: "No tiene responsable solidario"
    }

    mappings[rejected_reason.to_sym]
  end

  def self.second_interview_substate_to_human(second_interview_substate)
    mappings = {
      pending: "Pendiente",
      scheduled: "Agendada",
      finished: "Finalizó",
      pending_exercises: "Ejercicios por enviar",
      sent_exercises: "Ejercicios enviados"
    }

    mappings[second_interview_substate.to_sym]
  end
end
