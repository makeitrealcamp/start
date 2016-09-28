class EmailCommentJob < ActiveJob::Base
  queue_as :default

  def perform(comment_id)
    return unless Comment.exists?(comment_id)

    comment = Comment.find(comment_id)
    emails = []
    if comment.is_response? && comment.response_to.user != comment.user
      emails << comment.response_to.user.email
      UserMailer.comment_response(comment).deliver_now
    end

    admins_emails = (ENV['MENTORS_EMAILS'] || "").split(",")
    admins_emails.each do |email|
      unless emails.include? email
        admin = User.where(email: email).take
        AdminMailer.new_comment(email, admin, comment).deliver_now
      end
    end
  end
end
