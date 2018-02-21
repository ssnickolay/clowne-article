require 'securerandom'

class OrderNumberFactory
  class << self
    def generate
      SecureRandom.random_number(1_000_000)
    end
  end
end

class OrderCalculator
  class << self
    def perform(order)
      order.order_items.sum(&:price_cents) +
        order.additional_items.sum(&:price_cents)
    end
  end
end
