class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]
 
  
  def follow
    # Prevent users from following themselves
    if @user == current_user
      redirect_back(fallback_location: root_path, alert: "You cannot follow yourself.")
      return
    end

    # Check if already following or if a request is pending
    if current_user.following?(@user) || current_user.pending_follow_request?(@user)
      redirect_back(fallback_location: root_path, alert: "Already following or request pending.")
      return
    end

    # Create a follow request or follow directly
    follow_request = current_user.sent_follow_requests.new(recipient_id: @user.id, status: 'pending')  # or 'accepted' if instant follow
    if follow_request.save
      message = @user.private ? 'Follow request sent.' : 'Now following.'
      redirect_to users_path, notice: message
    else
      redirect_to users_path, alert: "Unable to send follow request."
    end
  end

  def index
    @list_of_users = User.all.order(username: :asc)
    render(template: "users_html/index")
  end

  def show
   
    @username = params.fetch("username")
    @the_user = User.where(username: @username).first

    if @the_user == nil
      redirect_to("/404")
    else
      render(template: "users_html/show")
    end
  end


  def create
    my_input_username = params.fetch("input_username")
    new_user = User.new
    new_user.username = my_input_username
    new_user.save
    redirect_to("/users/" + my_input_username)
  end


  def update
    user_id=current_user.id
    my_input_username = params.fetch("user[username]")
    the_user = User.where(id: user_id).first
    the_user.username = my_input_username
    the_user.save
    redirect_to("/users/" + my_input_username)
  end



  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to(users_path, alert: "User not found.")
  end
  
 
  
  def user_params
    params.require(:user).permit(:username)  # Make sure to permit any user parameters you expect from the form
  end

  def edit
    @user = current_user  # Devise provides this helper to access the currently signed-in user
    
    render(template: "users_html/edit")
  end

  

  # Check if the current user is following another user

  
end
