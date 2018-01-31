class AdditionItems::PackingCloner < Clowne::Cloner
  nullify :platform, :sticker_pack_id
end

class AdditionItems::GameCloner < Clowne::Cloner
  nullify :packing_type, :sticker_pack_id
end

class AdditionItems::StickerCloner < Clowne::Cloner
  nullify :platform, :packing_type

  finalize do |source, record|
    record.price_cents = source.sticker_pack.price_cents
  end
end

class OrderCloner < Clowne::Cloner
  include_association :order_items, -> (params) { joins(:product).where(products: { state: :available }) }
  include_association :addition_items

  finalize do |source, record, params|
    record.promotion_id = nil if source.promotion&.expired?
    record.number = OrderNumberFactory.generate
    record.total_cents = OrderCalculator.perform(record)
  end
end
