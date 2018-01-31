module AdditionItems
  class PackingCloner < Clowne::Cloner
    nullify :platform, :sticker_pack_id
  end

  class GameCloner < Clowne::Cloner
    nullify :packing_type, :sticker_pack_id
  end

  class StickerCloner < Clowne::Cloner
    nullify :platform, :packing_type

    finalize do |source, record|
      record.price_cents = source.sticker_pack.price_cents
    end
  end
end
