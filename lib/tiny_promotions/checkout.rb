require 'tiny_promotions/models/item'
require 'tiny_promotions/promotions/client'
require 'tiny_promotions/utils/string'

module TinyPromotions
  class Checkout
    attr_reader :items, :engine_client, :original_price, :tax_price
    attr_accessor :total, :discount

    def initialize(config={})
      @items = []
      reset_values!
      load_presets(config)
    end

    def scan(item)
      @items << item
      recalc!
      self
    end

    def recalc!
      reset_values!
      update_prices!(run_engines)
    end

    def log
      @engine_client.log
    end

    def original_price
      @original_price = @items.map(&:original_price).reduce(:+)
    end

    private

    def update_prices!(prices)
      #@total = prices[:total]
      #@discount = prices[:discount]
    end

    def reset_values!
      @total = original_price || 0.0
      @original_price = original_price || 0.0
      @discount = 0.0
      true
    end

    def run_engines
      @engine_client.call
    end

    def load_presets(config)
      @engine_client = TinyPromotions::Promotions::Client.new(config, self)
    end
  end
end
