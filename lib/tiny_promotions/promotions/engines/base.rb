require 'tiny_promotions/promotions/history/log_result'

module TinyPromotions::Promotions::Engines
  class Base
    attr_reader :context, :rules

    def initialize(context, rules={})
      @context = context
      post_initialize(rules)
    end

    def call
      calc_total
    end

    def result
      TinyPromotions::Promotions::History::LogResult.new(self)
    end

    def applies?
      raise MethodNotDefined
    end

    private

    def calc_total
      @total = @context.items.map{ |item| item.price }.reduce(:+)
    end

    def apply_discount
      [0.0, (@total - @discount).to_f].max
    end
  end
end
