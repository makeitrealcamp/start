# == Schema Information
#
# Table name: webinars_webinars
#
#  id          :bigint           not null, primary key
#  title       :string(150)      not null
#  slug        :string(100)      not null
#  description :text
#  date        :datetime         not null
#  image_url   :string
#  event_url   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category    :integer          default("webinar")
#
require 'rails_helper'

RSpec.describe Webinars::Webinar, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
