class SessionsController < ApplicationController
  
  def new
  	@title = "Sign in"
  end
   
	def create
		#hits self.authenticate in models/user.rb
		user = User.authenticate(params[:session][:email],
		                         params[:session][:password])
		if user.nil?
		  # Create an error message and re-render the signin form.
		  flash.now[:error] = "Invalid email/password combination."
		  @title = "Sign in"
		  render :new
		else
		flash[:success] = "Welcome back to Good Sounds #{user.name}!"
		
		# Hits sign_in in helpers/sessions_helper.rb
		# with user object returned by authenticate in user.rb 
		sign_in(user)
		
		# Sign the user in and redirect to the user's show page.
		redirect_back_or(user)
		end
	end
	
	def destroy
	
		#in session_helper.rb
		sign_out
		
		redirect_to root_path
	end

end
