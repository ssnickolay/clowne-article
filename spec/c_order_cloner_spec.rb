describe COrderCloner, with_stuff: true do
  describe '.call' do
    before do
      xbox_game_item
      promotion
    end

    it 'clone order' do
      cloned = described_class.call(order, traits: :repead)
      cloned.save

      expect(cloned.promotion_id).to eq(promotion.id)
      expect(cloned.number).not_to be_nil

      expect(cloned.order_items.count).to eq(2)
      expect(cloned.order_items.map(&:count)).to match_array([2, 3])
      expect(cloned.additional_items.count).to eq(1)
    end

    it 'werge with exists' do
      current_order = Order.create(number: 'some number')
      cloned = described_class.call(order,
        traits: :merge_with_current,
        current_order: current_order,
        order_item_count: 1
      )

      expect(cloned).to be_persisted
      expect(cloned.id).to eq(current_order.id)
      expect(cloned.number).to eq(current_order.number)

      expect(cloned.order_items.count).to eq(2)
      expect(cloned.order_items.map(&:count)).to match_array([1, 1])
      expect(cloned.additional_items.count).to be_zero

      expect(cloned.total_cents).not_to be_zero
    end
  end
end
