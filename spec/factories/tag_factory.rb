require 'faker'

FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.paragraph_by_chars(number: 4) }
    sign { Faker::Lorem.multibyte }
    kind { 'expenses' }
    user # 这个需要和 model 中的 belongs_to :user 搭配使用，和 user 无关，就不需要写
  end
end