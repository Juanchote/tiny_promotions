class ModifyPrice < TinyPromotions::Promotions::Engines::Base
  attr_reader :min_items, :code, :new_price

  def post_initialize(rules)
    @min_items  = rules.fetch(:min_items)
    @code       = rules.fetch(:code)
    @new_price  = rules.fetch(:new_price)
  end

  def applies?
    @context.items.select { |item| item.code.equals?(@code) } >= @min_items
  end
end
