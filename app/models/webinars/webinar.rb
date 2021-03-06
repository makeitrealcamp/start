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
  has_one_attached :image

  scope :upcoming, -> { where('date >= ?', Time.current + 1.hour).order(:date) }
  scope :past, -> { where('date <= ?', Time.current + 1.hour).order(date: :desc) }

  def is_past?
    date < Time.current
  end

  def is_upcoming?
    !is_past?
  end

  def url_encoded_title
    CGI.escape(title)
  end

  def url_encoded_description
    CGI.escape(description)
  end

  def date_in_timezone
    date.in_time_zone(-5)
  end
end
