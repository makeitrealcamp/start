module UsersHelper
  def name(user)
    n = user.active? ? "(#{user.first_name})" : ""
    "#{user.email} #{n}"
  end
end
