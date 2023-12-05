require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource '会话' do
  post '/api/v1/session' do
    parameter :email, '邮箱', required: true
    parameter :code, '验证码', required: true
    response_field :jwt, '用于验证用户身份的 token'
    let(:email) { '1@qq.com' }
    let(:code) { '123456' }
    example '登录' do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['jwt']).to be_a String
    end
  end

  get '/api/v1/refresh_jwt' do
    let(:current_user) { create :user }
    let(:auth) { "Bearer #{current_user.generate_jwt}" }
    authentication :basic, :auth
    example 'jwt 续签' do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['jwt']).to be_a String
      expect(json['refresh_jwt']).to be_a String
    end
  end
end