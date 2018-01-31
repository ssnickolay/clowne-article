class Order < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :payment_method

  has_many :order_items
  has_many :addition_items
end

class Promotion < ActiveRecord::Base; end
class PaymentMethod < ActiveRecord::Base; end

class OrderItem < ActiveRecord::Base
  belongs_to :product
end

class Product < ActiveRecord::Base
  enum state: [:available, :sold_out]
end
class AdditionItem < ActiveRecord::Base; end

module AdditionItems
  class Packing < ::AdditionItem
    enum packing_type: [:box, :package]

    def price_cents
      {
        box: 5_00,
        package: 3_50
      }[packing_type]
    end
  end

  class Game < ::AdditionItem
    enum platform: [:xbox, :ps4, :pc]

    def price_cents
      30_00
    end
  end

  class Sticker < ::AdditionItem
    belongs_to :sticker_pack
  end
end

class StickerPack < ActiveRecord::Base; end