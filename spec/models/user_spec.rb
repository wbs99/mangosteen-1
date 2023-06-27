require 'rails_helper'

RSpec.describe User, type: :model do
  it '有 email' do
    user = User.new email:'1134954328@qq.com'
    expect(user.email).to eq '1134954328@qq.com'
  end
end
