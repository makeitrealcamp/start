require 'rails_helper'

RSpec.feature "Comments management", type: :feature do
  let(:admin) { create(:admin) }

  scenario "deletes a comment", js: true do
    user = create(:user_with_path)
    challenge = create(:challenge, subject: create(:subject))
    comment = create(:comment, user: user, commentable: challenge)

    login(admin)

    visit(admin_comments_path)
    expect(page).to have_selector("#comment-#{comment.id}")

    find(:css, "#comment-#{comment.id} .comment-delete").click
    page.driver.browser.switch_to.alert.accept

    expect(page).to_not have_selector("#comment-#{comment.id}")
    expect(Comment.count).to eq 0
  end
end
