describe BOrderCloner, with_stuff: true do
  describe '.call' do
    it 'clone order' do
      cloned = described_class.call(order)
      cloned.save

      expect(cloned).to be_persisted
      expect(OrderItem.count).to eq(3 + 2)
      expect(cloned.order_items.count).to eq(2)
      expect(cloned.addition_items.count).to eq(1)

      expect(cloned.total_cents).to eq(2 * 41_00 + 3 * 28_50 + 5_00)
      expect(cloned.number).not_to eq(order)
    end
  end
end
