describe AOrderCloner do
  describe '.call' do
    let(:product1) { Product.create(name: 'R2-D2', price_cents: 41_00) }
    let(:product2) { Product.create(name: 'C-3PO', price_cents: 28_50) }

    let(:order) do
      Order.create(number: 'FF4321').tap do |o|
        OrderItem.create(count: 2, product: product1, price_cents: 2 * product1.price_cents, order_id: o.id)
        OrderItem.create(count: 3, product: product2, price_cents: 3 * product2.price_cents, order_id: o.id)
        AdditionItems::Packing.create(packing_type: :box, order_id: o.id)
      end
    end

    it 'clone order' do
      cloned = AOrderCloner.call(order)
      cloned.save

      expect(cloned).to be_persisted
      expect(OrderItem.count).to eq(4)
      expect(cloned.order_items.count).to eq(2)
      expect(cloned.addition_items.count).to eq(1)

      expect(cloned.total_cents).to eq(2 * 41_00 + 3 * 28_50 + 5_00)
      expect(cloned.number).not_to eq(order)
    end
  end
end
