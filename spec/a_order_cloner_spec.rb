describe AOrderCloner, with_stuff: true do
  describe '.call' do
    before { packaging_item }

    it 'clone order' do
      cloned = described_class.call(order)
      cloned.save

      expect(cloned).to be_persisted
      expect(OrderItem.count).to eq(3 + 2)
      expect(cloned.order_items.count).to eq(2)
      expect(cloned.additional_items.count).to eq(1)

      expect(cloned.total_cents).to eq(2 * 41_00 + 3 * 28_50 + 5_00)
      expect(cloned.number).not_to eq(order)

      cloned_addition_item = cloned.additional_items.first
      expect(cloned_addition_item.platform).to be_nil # nullify by cloner
    end
  end
end
