class Api::V1::RefreshJwtsController < ApplicationController
  def show
    user_id = request.env['current_user_id'] rescue nil
    user = User.find user_id
    return head 404 if user.nil?
    render json: { 
      jwt: user.generate_jwt,
      refresh_jwt:user.generate_refresh_jwt
    }
  end
end
