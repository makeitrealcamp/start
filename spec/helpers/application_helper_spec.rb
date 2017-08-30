require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper  do
  let!(:user)  { create(:user) }
  let!(:src) { Faker::Internet.url }

  describe "#embedded_video" do
    context 'when the video is not wistia provider' do
      it 'should return an iframe' do
        expect(embedded_video(src)).to have_selector('iframe')
      end
    end
  end
end
