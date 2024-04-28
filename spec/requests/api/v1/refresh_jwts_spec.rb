require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe 'Api::V1::RefreshJwts', type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe 'refresh_jwt 测试用例' do
    it '获取 refresh_jwt' do
      user = create:user
      get '/api/v1/refresh_jwt', headers: user.generate_refresh_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json['jwt']).to be_a String
      expect(json['refresh_jwt']).to be_a String
    end
    it 'refresh_jwt 过期' do
      travel_to Time.current - 8.days
      user = create:user
      headers = user.generate_refresh_auth_header

      travel_back
      get '/api/v1/refresh_jwt', headers: headers
      expect(response).to have_http_status(401)
    end
    it 'refresh_jwt 没过期' do
      travel_to Time.current - 6.days
      user = create:user
      headers = user.generate_refresh_auth_header
      
      travel_back
      get '/api/v1/refresh_jwt', headers: headers
      expect(response).to have_http_status(200)
    end
  end
end
