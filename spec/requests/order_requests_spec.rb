require 'rails_helper'

describe 'OrderRequestsController' do
  def create_timeseries_data!
    require 'active_support/testing/time_helpers'

    ActiveRecord::Base.transaction do
      50.times do |i|
        now = Time.new(2014, 5, 10, 0, 0, 0) + i
        extend ActiveSupport::Testing::TimeHelpers
        travel_to(now) do
          2.times do
            OrderRequest.create!(account_id: 1, body: '1')
            OrderRequest.create!(account_id: 0, body: '0')
          end
        end
      end
    end
  end

  def slice_attribute(object)
    object.slice('id', 'guid')
  end

  describe 'GET #index' do
    before do
      OrderRequestsController.paginatin_per_limit = 10
    end
    it '重複も取りこぼしもなく要素を返すこと' do
      base_query = OrderRequest.where(account_id: 1).order(:id)
      limit = OrderRequestsController.paginatin_per_limit
      create_timeseries_data!
      json_list = []
      next_url = '/order_requests?account_id=1'
      1.upto(OrderRequest.where(account_id: 1).count / limit) do |i|
        get(next_url)
        expected = base_query.page(i).per(limit).map { |o| slice_attribute(o) }
        json = JSON.parse(response.body)
        expect(expected).to eq(json['order_requests'].map{|o| slice_attribute(o) })
        json_list.concat(json['order_requests'])
        next_url = json['next_url']
      end
      expect(base_query.map { |o| slice_attribute(o) }).to eq(json_list.map { |o| slice_attribute(o) })
    end
  end
end

