class FooBars < TinyPromotions::Promotions::Engines::Base
  attr_reader :min_product_1, :code_1, :min_product_2, :code_2

  def post_initialize(rules)
    @min_product_1  = rules.fetch(:min_product_1)
    @code_1         = rules.fetch(:code_1)
    @min_product_2  = rules.fetch(:min_product_2)
    @code_2         = rules.fetch(:code_2)
  end

  def applies?
    @context.items.select { |item| item.code.equals?(@code_1) }.
      count {|items| items >= @min_product_1 } &&
      @context.items.select{ |item| item.code.equals?(@code_2) }.
      count {|items| items >= @min_product_2 }
  end
end

