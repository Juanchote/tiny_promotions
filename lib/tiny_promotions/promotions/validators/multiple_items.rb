require 'tiny_promotions/promotions/validators/base'

module TinyPromotions::Promotions::Validators
  class MultipleItems < Base
    attr_reader :min_items, :code

    def post_initialize(rules)
      @min_items  = rules.fetch(:min_items)
      @code       = rules.fetch(:code)
    end

    def applies?
      @context.items.select do |item|
        item.code == @code
      end.size >= @min_items
    end
  end
end
