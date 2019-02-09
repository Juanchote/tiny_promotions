module TinyPromotions::Promotions::Engines
  class MultipleItems < Base
    attr_reader :discount, :max, :code

    def post_initialize(rules)
      @discount, @min_items, @code = rules.dig(:discount), rules.dig(:min_items), rules.dig(:code)
    end

    def applies?
      @context.items.select do |item|
        item.code == @code
      end.size >= @min_items
    end
  end
end
