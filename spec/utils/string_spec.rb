RSpec.describe TinyPromotions::Utils::String do
  describe "with a foo_bar string" do
    it "expect to transform it in FooBar" do
      expect(TinyPromotions::Utils::String.camel_case('foo_bar')).to eq("FooBar")
    end
  end
end
