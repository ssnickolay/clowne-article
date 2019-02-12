class Order < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :payment_method

  has_many :order_items
  has_many :additional_items
  has_many :discounts

  def total
    total_discount = discounts.where(order_item_id: nil).sum(&:percent)
    PriceCalculator.(order_items.sum(&:total), total_discount)
  end
end

class PriceCalculator
  def self.call(price, discount)
    return 0 if discount >= 100

    price * (100 - discount) / 100
  end
end

class Discount < ActiveRecord::Base
  belongs_to :order
  belongs_to :order_item

  def total_percent
    ends_at >= DateTime.now ? percent : 0
  end
end

class Promotion < ActiveRecord::Base
  def expired?
    expires_at < DateTime.now
  end
end

class PaymentMethod < ActiveRecord::Base; end

class OrderItem < ActiveRecord::Base
  belongs_to :product
  has_one :discount

  scope :available, -> { joins(:product).where(products: { state: :available }) }

  def total
    return count * price_cents unless discount

    PriceCalculator.(count * price_cents, discount.total_percent)
  end
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
