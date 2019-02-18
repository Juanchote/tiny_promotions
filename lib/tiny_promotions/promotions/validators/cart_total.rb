require 'tiny_promotions/promotions/validators/base'

module TinyPromotions::Promotions::Validators
  class CartTotal < Base
    def post_initialize(rules)
      @min_total = rules.fetch(:min_total)
    end
    
    def applies?
      total >= @min_total
    end
  end
end
