require 'tiny_promotions/promotions/discount_processors/global'
require 'tiny_promotions/promotions/discount_processors/item'
require 'tiny_promotions/promotions/history/log_result'
require 'tiny_promotions/promotions/errors'

module TinyPromotions::Promotions::Validators
  class Base
    attr_reader :rules

    def initialize(context, rules={})
      @context        = context
      post_initialize(rules)
    end

    def call
      applies?
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

    def total
      @context.total
    end
  end
end
