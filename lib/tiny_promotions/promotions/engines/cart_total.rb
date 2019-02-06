require 'tiny_promotions/promotions/engines/base'

module TinyPromotions::Promotions::Engines
  class CartTotal < Base
    attr_reader :discount, :max

    def post_initialize(rules)
      @discount, @max = rules.dig(:discount), rules.dig(:max)
    end
    
    def call
      super
      @context.total = apply_discount if applies?
      self
    end

    def applies?
      @total >= @max
    end
  end
end
