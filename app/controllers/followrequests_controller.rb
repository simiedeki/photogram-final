class FollowRequestsController < ApplicationController
  before_action :authenticate_user!

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
