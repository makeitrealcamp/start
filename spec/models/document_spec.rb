# == Schema Information
#
# Table name: documents
#
#  id          :integer          not null, primary key
#  folder_id   :integer
#  folder_type :string
#  name        :string(50)
#  content     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_documents_on_folder_type_and_folder_id  (folder_type,folder_id)
#

require 'rails_helper'

RSpec.describe Document, type: :model do
  context 'associations' do
    it { should belong_to(:folder) }
  end

  it "has a valid factory" do
    expect(build(:document)).to be_valid
  end
end
