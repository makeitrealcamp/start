# == Schema Information
#
# Table name: webinars_participants
#
#  id         :bigint           not null, primary key
#  webinar_id :bigint
#  email      :string(150)      not null
#  first_name :string(100)      not null
#  last_name  :string(100)      not null
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webinars_participants_on_token       (token) UNIQUE
#  index_webinars_participants_on_webinar_id  (webinar_id)
#
FactoryGirl.define do
  factory :webinars_participant, :class => 'Webinars::Participant' do
    webinar ""
    email "MyString"
    first_name "MyString"
    last_name "MyString"
  end

end
