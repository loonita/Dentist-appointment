module ApplicationHelper

  def user_is_admin?(user = current_user)
    user && user.role_id == 1
  end

end
