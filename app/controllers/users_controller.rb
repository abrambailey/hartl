class UsersController < ApplicationController
	before_filter :authenticate, :except => [:show, :new, :create]
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user,   :only => :destroy
	before_filter :authenticate2,:only => [:new, :create]
	
  def new
  	@user = User.new
  	@title = "Sign up"
  end
  
  def show
  	@user = User.find(params[:id])
  	@microposts = @user.microposts.paginate(:page => params[:page], :per_page => 5)
  	@title = @user.name
	end

	def index 
		@title = "All users"
		#@users = User.all
		@users = User.paginate(:page => params[:page], :per_page => 5)
	end

	def create
    @user = User.new(params[:user])
    if @user.save
    	sign_in @user
      # Handle a successful save.
      flash[:success] = "Welcome to Good Sounds #{@user.name}!"
      redirect_to @user
    else
      @title = "Sign up"
      #@user.name = ""
      @user.password = ""
      render :new
    end
  end
  
  def edit
    #@user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      sign_in @user
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  private
  
  	def authenticate2
  		if signed_in?
  			redirect_to root_path, :notice => "Please log out to access that page."
			end
		end
		
		def authenticate
		    deny_access unless signed_in?
		end
		
		def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
