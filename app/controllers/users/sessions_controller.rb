class Users::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    if (session[:user_return_to])
      session[:user_return_to]
    elsif resource.show_welcome_screen?
      welcome_path
    else
      root_path
    end
  end
end
