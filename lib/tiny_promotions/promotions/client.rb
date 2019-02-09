require 'tiny_promotions/promotions/invoker'
require 'tiny_promotions/promotions/errors'
require 'tiny_promotions/promotions/engines/cart_total'
require 'tiny_promotions/promotions/engines/multiple_items'

module TinyPromotions::Promotions
  class Client
    attr_reader :invoker, :engines, :context

    ENGINES = {
      cart_total: TinyPromotions::Promotions::Engines::CartTotal,
      multiple_items: TinyPromotions::Promotions::Engines::MultipleItems
    }.freeze

    def initialize(config, context)
      @context = context
      @invoker = TinyPromotions::Promotions::Invoker.new
      @engines = []
      load_config(config)
    end

    def history
      @invoker.history
    end

    def find(name, params)
      raise Unknown, "Unknown promotion: #{name}" unless ENGINES.key?(name)

      ENGINES[name].new(@context, params)
    end

    def call
      @engines.each do |engine|
        @invoker.call(engine)
      end
    end

    private

    def load_config(ary)
      @engines = ary.map do |engine|
        temp = engine.dup
        name = temp.delete(:name)
        find(name.to_sym, temp)
      end
    end
  end
end
