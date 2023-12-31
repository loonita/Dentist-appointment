module ApplicationHelper

  # Check if the passed user is an admin
  # @return [Boolean] true if the current user is an admin, false otherwise
  def user_is_admin?(user = current_user)
    user && user.role_id == 4
  end

  def user_is_secretary?(user = current_user)
    user && user.role_id == 3
  end

  def user_is_dentist?(user = current_user)
    user && user.role_id == 2
  end

  def user_is_patient?(user = current_user)
    user && user.role_id == 1
  end

  def user_is_inactive?(user = current_user)
    user && user.role_id == 5
  end

  def current_user?(user = current_user)
    user
  end

end