class BOrderCloner < Clowne::Cloner
  include_association :addition_items
  include_association :order_items, -> (_params) { joins(:product).where(products: { state: :available }) }

  trait :repead do
    finalize do |source, record, _params|
      record.promotion_id = nil if source.promotion.expired?
      record.number = OrderNumberFactory.generate
    end
  end

  trait :merge_with_current do
    init_as { |source, current_order:| current_order }
  end

  finalize do |_source, record, _params|
    record.total_cents = OrderCalculator.perform(record)
  end
end
