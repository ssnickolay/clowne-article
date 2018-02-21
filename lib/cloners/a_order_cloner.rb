class AOrderCloner < Clowne::Cloner
  include_association :order_items, -> (_params) { joins(:product).where(products: { state: :available }) }
  include_association :additional_items

  finalize do |source, record, params|
    record.promotion_id = nil if source.promotion&.expired?
    record.number = OrderNumberFactory.generate
    record.total_cents = OrderCalculator.perform(record)
  end
end
