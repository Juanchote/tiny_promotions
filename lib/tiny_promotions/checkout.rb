require 'tiny_promotions/models/item'
require 'tiny_promotions/promotions/client'

module TinyPromotions
  class Checkout
    attr_reader :items, :engine_client
    attr_accessor :total

    def initialize(yaml)
      @items = []
      @total = 0.0
      load_presets(yaml)
    end

    def scan(item)
      @items << item
      @total = @items.reduce(0.0) { |acc, item| acc += item.price; acc }
      run_engines
      self
    end

    def history
      @engine_client.invoker.history
    end

    def config(&block)

    end

    private

    def run_engines
      @engine_client.call
    end

    def load_presets(config)
      @engine_client = TinyPromotions::Promotions::Client.new(config, self)
    end
  end
end
