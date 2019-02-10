require 'tiny_promotions/promotions/engines/base'

module TinyPromotions::Promotions::Engines
  class CartTotal < Base
    attr_reader :min_total

    def post_initialize(rules)
      @min_total = rules.dig(:min_total)
    end
    
    def applies?
      @total >= @min_total
    end
  end
end
