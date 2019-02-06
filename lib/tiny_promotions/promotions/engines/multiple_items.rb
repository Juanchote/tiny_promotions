module TinyPromotions::Promotions::Engines
  class MultipleItems < Base
    attr_reader :discount, :max, :code

    def post_initialize(rules)
      @discount, @max, @code = rules.dig(:discount), rules.dig(:max), rules.dig(:code)
    end

    def call
      super
      @context.total = apply_discount if applies?
      self
    end

    def applies?
      @context.items.select do |item|
        item.code == @code
      end.size >= @max
    end
  end
end
