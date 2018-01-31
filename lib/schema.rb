ActiveRecord::Schema.define do
  self.verbose = false

  create_table :payment_methods, force: true do |t|
    t.string :name
  end

  create_table :promotions, force: true do |t|
    t.integer :discount
    t.datetime :expires_at
  end

  create_table :orders, force: true do |t|
    t.belongs_to :promotion
    t.belongs_to :payment_method
    t.integer :state, default: 0, null: false
    t.string :number, null: false
    t.integer :total_cents, default: 0, null: false
    t.timestamps null: true
  end

  create_table :products, force: true do |t|
    t.string :name
    t.integer :state, default: 0, null: false
    t.integer :price_cents
    t.timestamps null: true
  end

  create_table :order_items, force: true do |t|
    t.belongs_to :product
    t.belongs_to :order
    t.integer :count, default: 1, null: false
    t.integer :price_cents, default: 0, null: false
    t.timestamps null: true
  end

  create_table :addition_items, force: true do |t|
    t.belongs_to :order
    t.integer :sticker_pack_id
    t.integer :platform, default: 0, null: false
    t.integer :packing_type, default: 0, null: false
    t.string :type, null: false
    t.integer :price_cents, default: 0, null: false
    t.timestamps null: true
  end

  create_table :sticker_packs, force: true do |t|
    t.string :name
    t.string :image
  end
end
