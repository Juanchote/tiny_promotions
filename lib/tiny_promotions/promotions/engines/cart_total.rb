require 'tiny_promotions/promotions/engines/base'

module TinyPromotions::Promotions::Engines
  class CartTotal < Base
    attr_reader :discount, :min_total

    def post_initialize(rules)
      @discount, @min_total = rules.dig(:discount), rules.dig(:min_total)
    end
    
    def applies?
      @total >= @min_total
    end
  end
end
