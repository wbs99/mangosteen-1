class Tag < ApplicationRecord  
  paginates_per 25
  enum kind: {expenses: 1, income: 2 }
  validates :name, presence: true,length: { maximum: 4 }
  validates :sign, presence: true
  validates :kind, presence: true
  belongs_to :user

  # 查询 tag 时，会默认加上 deleted_at 为空，并且按照 created_at 降序
  default_scope { where(deleted_at: nil).order(created_at: :desc) }
end
