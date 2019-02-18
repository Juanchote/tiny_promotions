require 'tiny_promotions/promotions/discount_processors/base'

module TinyPromotions::Promotions::DiscountProcessors
  class Item < Base

    private

    def code
      @code ||= @config.dig(:validator, :code)     
    end

    def items
      @context.items.select{ |item| item.code == code }
    end

    def update_prices(price)
      items.map { |item| item.update_price(price) }
      true
    end

    def get_original_price
      items[0].original_price
    end

    def percent_discount
      price = (get_original_price * (@discount_rules[:amount]/100.0)).to_f
      update_prices(price)
      price
    end

    def fixed_discount
      price = [0.0, get_original_price - @discount_rules[:amount].to_f].max
      update_prices(price)
      price
    end

    def apply_discount(total)
      @context.items.map(&:price).reduce(:+)
    end
  end
end
