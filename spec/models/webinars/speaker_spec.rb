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
require 'rails_helper'

RSpec.describe Webinars::Speaker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
