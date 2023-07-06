class Api::V1::ItemsController < ApplicationController
  def index
    current_user_id = request.env['current_user_id']
    return head :unauthorized if current_user_id.nil?
    items = Item.where({user_id: current_user_id})
      .where({created_at: params[:created_after]..params[:created_before]})
      .page(params[:page])
    render json: { resources: items, pager: {
      page: params[:page] || 1,
      per_page: Item.default_per_page,
      count: Item.count,
    } }
  end

  def create
    # 数组参数必须写在最后
    item = Item.new params.permit(:amount, :happen_at, tags_id: [] )  
    item.user_id = request.env['current_user_id']    
    if item.save
      render json: { resource: item }
    else
      render json: {errors: item.errors}, status: :unprocessable_entity
    end
  end

  def summary
    hash = Hash.new
    # hash 最终的格式  {2023-06-18:100,2023-06-19:200,2023-06-20:300}
    items = Item
      .where(user_id: request.env['current_user_id'])
      .where(kind: params[:kind])
      .where(happen_at: params[:happened_after]..params[:happened_before])
    items.each do |item|
      key = item.happen_at.in_time_zone('Beijing').strftime('%F')
      # 下面这两句是等价的
      # hash[key] = hash[key] || 0
      hash[key] ||= 0
      hash[key] += item.amount
    end
    # 遍历 hash 转换成数组
    groups = hash
      .map { |key, value| {"happen_at": key, amount: value} }
      .sort { |a, b| a[:happen_at] <=> b[:happen_at] }
    render json: {
      groups: groups,
      total: items.sum(:amount)
    }
  end
end