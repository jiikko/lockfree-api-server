require 'active_support/testing/time_helpers'
include ActiveSupport::Testing::TimeHelpers

travel_to Time.new(2014, 5, 10, 0, 0, 0) do
  ActiveRecord::Base.transaction do
    100.times do
      10.times do
        OrderRequest.create(account_id: 1, body: '1')
      end
      10.times do
        OrderRequest.create(account_id: 0, body: '2')
      end
    end
  end
end

