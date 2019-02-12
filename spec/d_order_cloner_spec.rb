describe DOrderCloner, with_stuff: true do
  describe '.call' do
    let(:order_total) { (200_00 * 0.9) * 0.8 }
    # before { packaging_item }

    it 'order total' do
      expect(order.total).to eq(order_total)
    end

    it 'cloner order' do
      operation = described_class.call(order, do_fix: false)
      operation.persist
      cloned = operation.to_record.reload

      expect(cloned.total).not_to eq(order_total)
    end

    it 'cloner with after_perist' do
      operation = described_class.call(order, do_fix: true)
      operation.persist!
      cloned = operation.to_record.reload

      expect(cloned.total).to eq(order_total)
    end
  end
end
