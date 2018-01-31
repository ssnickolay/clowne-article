class AOrderCloner < Clowne::Cloner
  include_association :order_items, -> (params) { joins(:product).where(products: { state: :available }) }
  include_association :addition_items

  finalize do |source, record, params|
    record.promotion_id = nil if source.promotion&.expired?
    record.number = OrderNumberFactory.generate
    record.total_cents = OrderCalculator.perform(record)
  end
end
