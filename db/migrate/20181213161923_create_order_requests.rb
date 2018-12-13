class CreateOrderRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :order_requests do |t|
      t.bigint :account_id, null: false, index: true
      t.string :guid, null: false
      t.string :body, null: false
      t.index [:account_id, :created_at]

      t.timestamps
    end
  end
end
