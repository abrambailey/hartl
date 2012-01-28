module SessionsHelper

  def sign_in(user)
  
  	#Creates secure token based on userid and salt
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    
    #Creates current_user, accessible to controllers (since sessions_helper was required in application_controller.rb)and views
    #which will allow constructions such as "current_user.name" and "redirect_to current user"
    self.current_user = user
  end
  
  def current_user=(user)
  	#Just assigns user to @current_user
    @current_user = user
  end
  
   def current_user
    @current_user ||= user_from_remember_token #calls user_from_remem private method (below)
    #assigns @current user based on remember token only when @current_user has not already been defined (by remember token) -- assigns first time and not again.
  end
  
  #You are signed in if the current user is not nil.
  def signed_in?
  	!current_user.nil?
	end
	
	def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def deny_access
  	store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  # this uses location stored from deny_access above to forward once user has signed in
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) 
      # '*' allows array to pass in as multiple arguments (taken from array values) rather than as a single object (array)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
