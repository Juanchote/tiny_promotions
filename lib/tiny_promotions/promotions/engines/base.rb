require 'tiny_promotions/promotions/history/log_result'

module TinyPromotions::Promotions::Engines
  class Base
    attr_reader :context, :rules

    def initialize(context, rules={})
      @context = context
      @discount_rules = rules.dig(:discount)
      post_initialize(rules)
    end

    def call
      calc_total
      return self unless applies?

      @context.discount += calc_discount
      @context.total = apply_discount
      self
    end

    def result
      TinyPromotions::Promotions::History::LogResult.new(self)
    end

    def applies?
      raise MethodNotDefined
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end

    def self.subclasses
      subclasses, chain = [], descendants
      chain.each do |k|
        subclasses << k unless chain.any? { |c| c > k }
      end
      subclasses
    end


    private

    def calc_discount
      @discount = case @discount_rules.dig(:type)
        when 'fixed' then fixed_discount
        when  'percent' then percent_discount
      end
    end

    def percent_discount
      (@total * (@discount_rules.dig(:amount)/100)).to_f
    end

    def fixed_discount
      @discount_rules.dig(:amount).to_f
    end

    def calc_total
      @total = @context.items.map(&:price).reduce(:+)
    end

    def apply_discount
      [0.0, (@total - @discount).to_f].max
    end
  end
end
