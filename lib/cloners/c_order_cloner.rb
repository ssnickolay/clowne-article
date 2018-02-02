class COrderCloner < Clowne::Cloner
  include_association :addition_items

  trait :repead do
    include_association :order_items, :available

    finalize do |source, record, _params|
      record.promotion_id = nil if source.promotion.expired?
      record.number = OrderNumberFactory.generate
    end
  end

  trait :merge_with_current do
    include_association :order_items, :available, clone_with: CountableOrderItemCloner
    exclude_association :addition_items

    init_as { |source, current_order:, **| current_order }
  end

  finalize do |_source, record, _params|
    record.total_cents = OrderCalculator.perform(record)
  end
end

class CountableOrderItemCloner < Clowne::Cloner
  finalize do |source, record, order_item_count:, **|
    record.count = order_item_count || 1
  end

  # or you can do it
  # finalize do |source, record, params|
  #   record.count = order_item_count = params[:order_item_count]
  # end
end
