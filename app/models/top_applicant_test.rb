# == Schema Information
#
# Table name: top_applicant_tests
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  a1           :string
#  a2           :text
#  a3           :text
#  a4           :text
#  comments     :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  lang         :integer          default("javascript")
#
# Indexes
#
#  index_top_applicant_tests_on_applicant_id  (applicant_id)
#

class TopApplicantTest < ApplicationRecord
  belongs_to :applicant

  validates :applicant, :a1, :a2, :a3, presence: true
  enum lang: [:javascript, :ruby, :python, :php, :java, :cplus, :csharp]

  def version
    return 1 if applicant.version.nil?
    return applicant.version
  end
end
