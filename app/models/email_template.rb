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

class EmailTemplate < ActiveRecord::Base
end
