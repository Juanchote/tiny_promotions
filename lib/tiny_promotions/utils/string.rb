module TinyPromotions::Utils
  class String
    def self.camel_case(string)
      string.split('_').map(&:capitalize).join
    end
  end
end
