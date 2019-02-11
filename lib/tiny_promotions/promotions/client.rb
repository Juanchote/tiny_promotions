require 'tiny_promotions/promotions/invoker'
require 'tiny_promotions/promotions/errors'
require 'tiny_promotions/promotions/engines/cart_total'
require 'tiny_promotions/promotions/engines/multiple_items'

module TinyPromotions::Promotions
  class Client
    attr_reader :invoker, :engines, :context, :path

    ENGINES = {
      cart_total: TinyPromotions::Promotions::Engines::CartTotal,
      multiple_items: TinyPromotions::Promotions::Engines::MultipleItems
    }

    def initialize(config, context)
      @context = context
      @invoker = TinyPromotions::Promotions::Invoker.new
      @engines = []
      load_config(config)
    end

    def log
      @invoker.log
    end

    def find(name, params)
      raise Unknown, "Unknown promotion: #{name}" unless ENGINES.key?(name)

      ENGINES[name].new(@context, params)
    end

    def call
      @invoker.purge!
      @engines.each do |engine|
        @invoker.call(engine)
      end
    end

    private

    def require_engines
      Dir["#{@path}/*" ].select{ |f| File.file? f }.map{ |f| File.basename(f,File.extname(f)) }.each{ |file| Kernel.require(file) }
    end

    def merge_engines
      ENGINES.merge!(TinyPromotions::Promotions::Engines::Base.subclasses.reduce(Hash.new) do |hash, lib|
        hash[TinyPromotions::Utils::String.snake_case(lib.name.split('::').last).to_sym] = lib
        hash
      end)
    end

    def load_path(path)
      @path = File.expand_path("#{path}")
      $LOAD_PATH.unshift(@path) unless $LOAD_PATH.include?(@path)
    end

    def load_config(config)
      unless config.dig(:path).nil?
        load_path(path = config.dig(:path))
        require_engines
        merge_engines
      end

      @engines = config.dig(:engines).map do |engine|
        temp = engine.dup
        name = temp.delete(:name)
        find(name.to_sym, temp)
      end
    end
  end
end
