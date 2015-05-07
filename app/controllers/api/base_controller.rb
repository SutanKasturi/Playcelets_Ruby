class Api::BaseController < ActionController::Base
  # acts_as_token_authentication_handler_for User, fallback_to_devise: false
  
  # before_action :authenticate_user!

  # # Prevent CSRF attacks by raising an exception.
  # # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  alias_method :devise_current_user, :current_user

  def auth_user
  	@token = params[:token]
    p "#{@token}"
  	@user = User.find_by_authentication_token(@token)
  	if @user.role == "parent"
		@user_parent = true
	elsif @user.role == "admin"
		@user_admin = true
	elsif @user.role == "child"
		@user_child = true
	end
  end

  def current_user
  	p "$$$$$$$$$$------FINDING CURRENT USER--------$$$$$$$$$$$"
  	@token = params[:token]
  	User.find_by_authentication_token(@token)  	
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  # before_action :authenticate_user!
end
