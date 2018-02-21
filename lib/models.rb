class Order < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :payment_method

  has_many :order_items
  has_many :additional_items
end

class Promotion < ActiveRecord::Base
  def expired?
    expires_at < DateTime.now
  end
end

class PaymentMethod < ActiveRecord::Base; end

class OrderItem < ActiveRecord::Base
  belongs_to :product
  scope :available, -> { joins(:product).where(products: { state: :available }) }
end

class Product < ActiveRecord::Base
  enum state: [:available, :sold_out]
end
class AdditionalItem < ActiveRecord::Base; end

module AdditionalItems
  class Packaging < ::AdditionalItem
    enum packaging_type: [:box, :package]

    def price_cents
      {
        box: 5_00,
        package: 3_50
      }[packaging_type.to_sym]
    end
  end

  class Game < ::AdditionalItem
    enum platform: [:xbox, :ps4, :pc]

    def price_cents
      30_00
    end
  end

  class Sticker < ::AdditionalItem
    belongs_to :sticker_pack
  end
end

class StickerPack < ActiveRecord::Base; end
