module AdditionItems
  class PackagingCloner < Clowne::Cloner
    nullify :platform, :sticker_pack_id
  end

  class GameCloner < Clowne::Cloner
    nullify :packaging_type, :sticker_pack_id
  end

  class StickerCloner < Clowne::Cloner
    nullify :platform, :packaging_type

    finalize do |source, record|
      record.price_cents = source.sticker_pack.price_cents
    end
  end
end
