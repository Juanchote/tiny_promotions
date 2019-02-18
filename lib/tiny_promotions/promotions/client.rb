require 'tiny_promotions/promotions/invoker'
require 'tiny_promotions/promotions/errors'
require 'tiny_promotions/promotions/engine'
require 'tiny_promotions/promotions/validators/cart_total'
require 'tiny_promotions/promotions/validators/multiple_items'

module TinyPromotions::Promotions
  class Client
    ENGINES = {
      cart_total:     TinyPromotions::Promotions::Validators::CartTotal,
      multiple_items: TinyPromotions::Promotions::Validators::MultipleItems
    }

    DISCOUNT_PROCESSORS = {
      global: TinyPromotions::Promotions::DiscountProcessors::Global,
      item:   TinyPromotions::Promotions::DiscountProcessors::Item
    }.freeze

    def initialize(config, context)
      @config = config
      @context = context
      @invoker = TinyPromotions::Promotions::Invoker.new
      @engines = []
      load_config(config)
    end

    def log
      @invoker.log
    end

    def call
      @invoker.purge!
      @engines.each do |engine|
        @invoker.call(engine.discount_processor) if @invoker.call(engine.validator)
      end
    end

    private

    def find_engine(name, params)
      raise Unknown, "Unknown promotion: #{name}" unless ENGINES.key?(name)

      ENGINES[name].new(@context, params)
    end

    def find_discount_processor(name, params)
      raise Unknown, "Unknown promotion: #{name}" unless DISCOUNT_PROCESSORS.key?(name)

      DISCOUNT_PROCESSORS[name].new(@context, params)
    end

    def require_engines
      Dir["#{@path}/*" ].
        select{ |f| File.file? f }.
        map{ |f| File.basename(f,File.extname(f)) }.
        each{ |file| Kernel.require(file) }
    end

    def merge_engines
      ENGINES.merge!(TinyPromotions::Promotions::Validators::Base.subclasses.reduce(Hash.new) do |hash, lib|
        hash[TinyPromotions::Utils::String.snake_case(lib.name.split('::').last).to_sym] = lib
        hash
      end)
    end

    def load_path(path)
      @path = File.expand_path("#{path}")
      $LOAD_PATH.unshift(@path) unless $LOAD_PATH.include?(@path)
    end

    def load_config(config)
      unless config.fetch(:path, nil).nil?
        load_path(path = config[:path])
        require_engines
        merge_engines
      end

      engines = config.fetch(:engines, [])
      @engines = engines.map do |engine|
        TinyPromotions::Promotions::Engine.new(
                                 validator: find_engine(engine[:name].to_sym,
                                                        engine[:validator]),
        discount_processor: find_discount_processor(engine.dig(:discount, :apply_to).to_sym,
                                                      engine)
        )
      end
    end

    def validate_discount_rules(discount_rules)
      discount_rules.fetch(:type)
      discount_rules.fetch(:amount)
      discount_rules.fetch(:apply_to)
    end
  end
end
