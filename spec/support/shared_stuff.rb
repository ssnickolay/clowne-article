shared_context 'shared stuff', with_stuff: true do
  before do
    ActiveRecord::Base.subclasses.each do |ar_class|
      ar_class.delete_all
    end
  end

  let!(:product1) { Product.create(name: 'R2-D2', price_cents: 41_00) }
  let!(:product2) { Product.create(name: 'C-3PO', price_cents: 28_50) }
  let!(:sold_out_product) { Product.create(name: 'Leia Organa', price_cents: 500_00, state: :sold_out) }

  let!(:order) do
    Order.create(number: 'FF4321').tap do |o|
      [product1, product2, sold_out_product].each_with_index do |product, index|
        count = index + 2
        OrderItem.create(
          count: count,
          product: product,
          price_cents: count * product.price_cents,
          order_id: o.id
        )
      end
      AdditionItems::Packing.create(packing_type: :box, order_id: o.id)
    end
  end
end
