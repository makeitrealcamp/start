# == Schema Information
#
# Table name: webinars_speakers
#
#  id         :bigint           not null, primary key
#  webinar_id :bigint
#  name       :string           not null
#  avatar_url :string
#  bio        :string
#  external   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_webinars_speakers_on_webinar_id  (webinar_id)
#
FactoryGirl.define do
  factory :webinars_speaker, :class => 'Webinars::Speaker' do
    webinar future_webinar
name "MyString"
avatar_url "MyString"
role "MyString"
external false
  end

end
