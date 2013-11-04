require "transmogrifier"

describe Transmogrifier::Rules::Append do
  let(:input_hash) do
    { "key" => "value", "array" => [] }
  end

  context "when the selector finds a HashNode" do
    subject(:append) { described_class.new("", {"new_key" => "new_value"}) }
    it "appends to the hash" do
      expect(append.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [],
        "new_key" => "new_value",
      })
    end
  end

  context "when the selector finds an ArrayNode" do
    subject(:append) { described_class.new("array", {"new_key" => "new_value"}) }

    it "appends to the array" do
      expect(append.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [{"new_key" => "new_value"}],
      })
    end
  end
end
