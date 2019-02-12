shared_context 'shared stuff', with_stuff: true do
  before do
    ActiveRecord::Base.subclasses.each do |ar_class|
      ar_class.delete_all
    end
  end

  let!(:product1) { Product.create(name: 'R2-D2', price_cents: 100_00) }
  let!(:product2) { Product.create(name: 'C-3PO', price_cents: 28_50) }
  let!(:sold_out_product) { Product.create(name: 'Leia Organa', price_cents: 500_00, state: :sold_out) }

  let!(:order) do
    Order.create(number: 'FF4321').tap do |o|
      [product1].each_with_index do |product, index|
        count = index + 2
        OrderItem.create(
          count: 2,
          product: product,
          price_cents: 1 * product.price_cents,
          order_id: o.id
        )
      end
    end
  end

  let!(:order_discount) do
    Discount.create(percent: 20, order: order, ends_at: 1.days.from_now)
  end

  let!(:order_item_discount) do
    Discount.create(
      percent: 10,
      order: order,
      order_item_id: order.order_items.sample.id,
      ends_at: 1.days.from_now
    )
  end

  let(:packaging_item) do
    AdditionalItems::Packaging.create(
      platform: :ps4,
      packaging_type: :box,
      order_id: order.id
    )
  end

  let(:xbox_game_item) do
    AdditionalItems::Game.create(
      platform: :xbox,
      packaging_type: :box,
      order_id: order.id
    )
  end

  let(:promotion) do
    Promotion.create(
      discount: 100_00,
      expires_at: DateTime.new(2019, 2, 3, 4, 5, 6)
    ).tap do |p|
      order.update_attributes(promotion_id: p.id)
    end
  end
end
