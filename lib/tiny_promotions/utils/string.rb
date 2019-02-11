module TinyPromotions::Utils
  class String
    def self.camel_case(string)
      string.split('_').map(&:capitalize).join
    end

    def self.snake_case(string)
      string.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
