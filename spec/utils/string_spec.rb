RSpec.describe TinyPromotions::Utils::String do
  describe "with a foo_bar string" do
    it "expect to transform it in FooBar" do
      expect(TinyPromotions::Utils::String.camel_case('foo_bar')).to eq("FooBar")
    end
  end

  describe "with a FooBar string" do
    it "expect to transform it in foo_bar" do
      expect(TinyPromotions::Utils::String.snake_case('FooBar')).to eq("foo_bar")
    end
  end
end
