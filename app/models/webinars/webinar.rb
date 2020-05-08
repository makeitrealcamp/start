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
#
class Webinars::Webinar < ApplicationRecord
  has_many :speakers
  has_many :participants

  scope :upcoming, -> { where('date >= ?', Time.current).order(:date) }
  scope :past, -> { where('date <= ?', Time.current).order(date: :desc) }

  def is_past?
    date < Time.current
  end

  def is_upcoming?
    !is_past?
  end
end
