module TinyPromotions::Promotions::DiscountProcessors
  class Base
    def initialize(context, config)
      @context = context
      @config = config
      @discount_rules = config[:discount]
    end

    def call
      @total = total
      @discount = case @discount_rules[:type]
        when 'fixed'    then fixed_discount
        when 'percent'  then percent_discount
      end
      @context.total = apply_discount(@context.total)
    end

    def total
      @total = @context.items.map(&:price).reduce(:+) || 0.0
    end
  end
end
