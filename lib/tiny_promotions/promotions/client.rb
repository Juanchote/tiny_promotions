require 'tiny_promotions/promotions/invoker'
require 'tiny_promotions/promotions/errors'
require 'tiny_promotions/promotions/engines/cart_total'
require 'tiny_promotions/promotions/engines/multiple_items'

module TinyPromotions::Promotions
  class Client
    attr_reader :invoker, :engines, :context

    ENGINES = {
      cart_total: TinyPromotions::Promotions::Engines::CartTotal
    }.freeze

    def initialize(config, context)
      @context = context
      @invoker = TinyPromotions::Promotions::Invoker.new
      @engines = []
      @engines << TinyPromotions::Promotions::Engines::CartTotal.new(context, { discount: 10, max: 50 })
      @engines << TinyPromotions::Promotions::Engines::MultipleItems.new(context, { discount: 20, max: 2, code: "foo" })
    end

    def find(name)
      raise Unknown, "Unknown promotion: #{name}" unless ENGINES.key?(name)

      ENGINES[name].new(params={})
    end

    def call
      @engines.each do |engine|
        @invoker.call(engine)
      end
    end
  end
end
