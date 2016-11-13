concern :CurrentUser do

  included do
    helper_method :current_user
    before_action :create_guest_user_from_form_data, only: [:create]
  end

  # This method returns the currently signed in user.
  #
  def current_user
    @current_user ||= current_devise_user || current_user_by_auth_token || guest_user_by_cookie
  end

  def current_devise_user
    current_user_account.try(:user)
  end

  def current_user_by_auth_token
    AuthToken.where(token: current_auth_token).first.try(:user) if current_auth_token
  end

  def current_auth_token
    cookies[:token] = params[:token] if params[:token]
    cookies[:token]
  end

  def guest_user_by_cookie
    GuestUser.find_by_email(cookies[:guest_user_email]) if cookies[:guest_user_email].present?
  end

  def create_guest_user_from_form_data
    if params[:guest_user_name].present? && params[:guest_user_email].present?
      cookies[:guest_user_email] = params[:guest_user_email]
      GuestUser.find_or_create(params[:guest_user_name], params[:guest_user_email])
      # TODO: Ask the user to sign in if user.account
    end
  end

end