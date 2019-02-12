class DDiscountCloner < Clowne::Cloner
  # include_association :discount

  after_persist do |origin, cloned, mapper:, do_fix: |
    next unless do_fix

    order_item = mapper.clone_of(origin.order_item)
    cloned.update_attributes(order_item_id: order_item.id) if order_item
  end
end

class DOrderCloner < Clowne::Cloner
  include_association :order_items
  include_association :discounts, clone_with: DDiscountCloner, params: true
end
