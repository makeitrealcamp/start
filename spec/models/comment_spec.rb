# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_id   :integer
#  commentable_type :string
#  text             :text
#  response_to_id   :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

require 'rails_helper'

RSpec.describe Comment, type: :model do

  subject { Comment.new }

  context "associations" do
    it { should belong_to(:commentable) }
    it { should belong_to(:user) }
    it { should belong_to(:response_to).class_name('Comment') }
  end

  context "validations" do
    it { should validate_presence_of :commentable }
    it { should validate_presence_of :user }
    it { should validate_presence_of :text }
  end

  it "has a valid factory" do
    expect(build(:comment)).to be_valid
  end

  context "when comment is a response" do
    it "doesn't allow a response to another response" do
      comment = create(:comment)
      response = create(:comment, response_to: comment)

      response_to_response = build(:comment,response_to: response)
      expect(response_to_response).to_not be_valid
      expect(response_to_response.errors).to have_key(:response_to)
    end
  end
end
