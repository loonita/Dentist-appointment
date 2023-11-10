module ApplicationHelper

  # Check if the passed user is an admin
  # @return [Boolean] true if the current user is an admin, false otherwise
  def user_is_admin?(user = current_user)
    user && user.role_id == 4
  end

end
