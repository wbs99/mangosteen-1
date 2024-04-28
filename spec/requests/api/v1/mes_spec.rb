require 'rails_helper'
require 'active_support/testing/time_helpers'


RSpec.describe "Me", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "获取当前用户" do
    it "登录后成功获取" do
      expect {
        post '/api/v1/session', params: {email: '1134954328@qq.com', code: '123456'}
      }.to change { User.count }.by +1
      expect(response).to have_http_status(200)
      json = JSON.parse response.body

      user = create:user
      get '/api/v1/me', headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json['resource']['id']).to be_a Numeric
    end
    it "jwt过期" do
      travel_to Time.current - 3.hours
      user = create:user
      headers = user.generate_auth_header

      travel_back
      get '/api/v1/me', headers: headers
      expect(response).to have_http_status(401)
    end
    it "jwt没过期" do
      travel_to Time.current - 1.hours
      user = create:user
      headers = user.generate_auth_header

      travel_back
      get '/api/v1/me', headers: headers
      expect(response).to have_http_status(200)
    end
  end
end