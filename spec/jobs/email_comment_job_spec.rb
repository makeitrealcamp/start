require 'rails_helper'

RSpec.describe EmailCommentJob, type: :job do
  before do
    ActionMailer::Base.deliveries.clear
    ENV['MENTORS_EMAILS'] = ""
  end

  it "sends comment email to admins" do
    comment = create(:comment)

    ENV['MENTORS_EMAILS'] = "test1@example.com,test2@example"
    expect {
      EmailCommentJob.perform_now(comment.id)
    }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end

  it "sends response comment email to commentor" do
    comment = create(:comment)

    # create a response comment
    user = create(:user)
    response = create(:comment, response_to: comment, user: user)

    expect {
      EmailCommentJob.perform_now(response.id)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to include(comment.user.email)
  end

  it "only sends one email if admin same as commentor" do
    admin = create(:admin_user)
    comment = create(:comment, user: admin)

    response = create(:comment, response_to: comment)

    ENV['MENTORS_EMAILS'] = admin.email
    expect {
      EmailCommentJob.perform_now(response.id)
    }.to change { ActionMailer::Base.deliveries.count }.by(1)

    email = ActionMailer::Base.deliveries.last
    expect(email.to).to include(admin.email)
  end
end
