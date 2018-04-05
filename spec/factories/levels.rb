# == Schema Information
#
# Table name: levels
#
#  id              :integer          not null, primary key
#  name            :string
#  required_points :integer
#  image_url       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :level do
    name "Teclado Blanco"
    required_points 0
    image_url "https://s3.amazonaws.com/makeitreal/levels/nivelBlanco%402x.png"
  end
end
