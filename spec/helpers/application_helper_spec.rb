require "rails_helper"

RSpec.describe ApplicationHelper, :type => :helper  do
  let!(:user)  { create(:user) }
  let!(:src) { Faker::Internet.url }

  describe "#embedded_video" do
    context 'when the video is of wistia provider' do
      it 'should return an div' do
        src  = "http://fast.wistia.net/embed/iframe/es7g1ii56j"
        video = embedded_video(src, user: user)
        expect(video).to have_selector('div')
        expect(video).to have_selector('#wistia_es7g1ii56j')
      end
    end

    context 'when the video is not wistia provider' do
      it 'should return an iframe' do
        expect(embedded_video(src)).to have_selector('iframe')
      end
    end
  end
end
