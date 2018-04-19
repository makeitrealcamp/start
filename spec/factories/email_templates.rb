# == Schema Information
#
# Table name: email_templates
#
#  id         :integer          not null, primary key
#  title      :string
#  subject    :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :email_template do
    title "Plantilla 1"
    subject "Este es el asunto"
    body "Este es el cuerpo"
  end

end
