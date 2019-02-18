require 'tiny_promotions/promotions/discount_processors/base'

module TinyPromotions::Promotions::DiscountProcessors
  class Global < Base

    def call
      super
    end

    def percent_discount
      (@total * (@discount_rules[:amount]/100.0)).to_f
    end

    def fixed_discount
      @discount_rules[:amount].to_f
    end


    private

    def apply_discount(total)
      [0.0, (total - @discount).to_f].max
    end
  end
end

