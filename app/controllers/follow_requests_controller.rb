class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

  def create

    recipient_id = params.fetch("query_recipient_id")
    recipient = User.find_by(id: recipient_id)

    # Check if recipient exists and is not private
    if recipient.nil?
      redirect_to("/users", alert: "User not found.") and return
    end

    a = FollowRequest.new(sender_id: current_user.id, recipient_id: recipient_id)

    # Set the status based on the recipient's privacy settings
    if recipient.private?
      a.status = 'pending'
    else
      a.status = 'accepted'
    end
    if a.save
      redirect_to users_path, notice: "Follow request #{a.status}."
    else
      redirect_to users_path, alert: "Failed to send follow request."
    end
   
    
   
  end


  
end
