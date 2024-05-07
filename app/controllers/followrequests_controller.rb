class FollowrequestsController < ApplicationController
  before_action :authenticate_user!
  def create
    a= FollowRequest.new
    recipient_id = params.fetch("query_recipient_id")
    a.sender_id=current_user.id
    a.recipient_id=recipient_id
    if  a.recipient_id=User.where(private: 'false')
      a.status=='accepted'
    else 
      a.status=='pending'
    end
    a.save

    redirect_to("/users/") 
   end

  def index
    @incoming_requests = current_user.received_follow_requests.where(status: 'pending')
  end

  def update
    follow_request = FollowRequest.find(params[:id])
    if params[:accept]
      follow_request.update(status: 'accepted')
      notice = 'Follow request accepted.'
    else
      follow_request.destroy
      notice = 'Follow request declined.'
    end
    redirect_to follow_requests_path, notice: notice
  end
end
