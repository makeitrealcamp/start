require 'rails_helper'

RSpec.feature "Comments", type: :feature do

  let!(:user)      { create(:paid_user) }
  let!(:admin )    { create(:admin) }
  let!(:course)    { create(:course) }
  let!(:challenge) { create(:challenge, course: course) }
  let!(:solution)  { create(:solution, user: user, challenge: challenge, status: :completed, completed_at: 1.week.ago) }
  let!(:comment)   { create(:comment, user: user, commentable: challenge) }

  context 'as user not logged in' do
    scenario 'should not allow access' do
      expect { visit admin_comments_path }.to raise_error ActionController::RoutingError
    end
  end

  context 'when accessed as user' do
    scenario 'should not allow access' do
      expect { visit admin_comments_path }.to raise_error ActionController::RoutingError
    end

    context 'when the challenge is completed' do
      scenario 'Display comments', js: true do
        login(user)
        visit discussion_course_challenge_path(challenge.course, challenge)
        wait_for_ajax
        expect(current_path).to eq discussion_course_challenge_path(challenge.course, challenge)
      end

      context 'create comment', js: true do
        scenario 'with valid input', js: true do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          fill_in 'text', with: Faker::Lorem.paragraph
          click_button "Comentar"
          wait_for_ajax

          expect(Comment.count).to eq 2
          expect(page).to have_selector('.discussion-entry', count: 2)
        end

        scenario 'without input' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          click_button "Comentar"
          wait_for_ajax

          expect(Comment.count).to eq 1
          expect(page).to have_selector('article.discussion-entry', count: 1)
        end
      end


      context 'update comment', js: true do
        scenario 'display form' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.comment-actions a .glyphicon.glyphicon-pencil').first.click
          wait_for_ajax
          expect(page).to have_selector 'form.edit-comment'
        end

        scenario 'with valid input' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.comment-actions a .glyphicon.glyphicon-pencil').first.click
          text = Faker::Lorem.paragraph

          find(:css, 'form.edit-comment textarea#comment-input').set(text)
          click_button "Actualizar comentario"
          wait_for_ajax
          expect(Comment.last.text).to eq text
          expect(page).to have_content text
        end

        scenario 'without input' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.comment-actions a .glyphicon.glyphicon-pencil').first.click
          find(:css, 'form.edit-comment textarea#comment-input').set('')
          click_button "Actualizar comentario"
          wait_for_ajax
          expect(page).to have_selector 'form.edit-comment'
        end

        scenario 'cancel comment edition' do
          original_comment_text = comment.text
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.comment-actions a .glyphicon.glyphicon-pencil').first.click
          find(:css, 'form.edit-comment textarea#comment-input').set('XXX')
          click_link "Cancelar"
          wait_for_ajax
          expect(page).to have_content original_comment_text
          expect(comment.reload.text).to eq(original_comment_text)
          expect(page).to_not have_selector('form.edit-comment')
        end
      end

      scenario 'Remove comment', js: true do
        comment1 = create(:comment, user: user, commentable: challenge)
        login(user)
        visit discussion_course_challenge_path(challenge.course, challenge)
        all(:css, '.comment-actions a .glyphicon.glyphicon-remove').first.click
        handle_confirm
        wait_for_ajax
        expect(Comment.count).to eq 1
        expect(page).to have_selector('article.discussion-entry', count: 1)
      end

      context 'response comments', js: true do
        scenario 'display form' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.add-form-response').first.click
          wait_for_ajax
          expect(page).to have_selector('.response-comment-form form', count: 1)
        end

        scenario 'with valid input' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.add-form-response').first.click
          wait_for_ajax
          text = Faker::Lorem.paragraph
          find(:css, '.responses-to-comment form textarea').set(text)
          click_button 'Responder'
          wait_for_ajax
          answer = comment.responses.last
          expect(comment.responses.count).to eq 1
          expect(answer.response_to_id).to eq comment.id
          expect(answer.text).to eq text
          expect(page).not_to have_selector('.response-comment-form form')
          expect(page).to have_selector('.responses-to-comment .discussion-entry', count: 1)
        end

        scenario 'without valid input' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.add-form-response').first.click
          wait_for_ajax
          click_button 'Responder'
          wait_for_ajax
          expect(comment.responses.count).to eq 0
          expect(page).to have_selector('.response-comment-form form')
        end

        scenario 'with cancel form' do
          login(user)
          visit discussion_course_challenge_path(challenge.course, challenge)
          all(:css, '.add-form-response').first.click
          wait_for_ajax
          click_link 'Cancelar'
          expect(page).not_to have_selector('.response-comment-form form')
        end
      end

    end

    context 'when the challenge is not completed' do
      scenario 'display form comments', js: true do
        challenge = create(:challenge, course: course)
        solution = create(:solution, user: user, challenge: challenge)
        login(user)

        visit discussion_course_challenge_path(challenge.course, challenge)

        wait_for_ajax
        expect(page).to have_content 'Debes completar el reto para poder ver la discusión'
      end
    end
  end
end
