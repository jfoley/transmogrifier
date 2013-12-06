require "transmogrifier"

describe Transmogrifier::Rules::Delete do
  let(:input_hash) do
    {
      "key" => "value",
      "array" => [{"inside" => "value"}],
      "nested" => {
        "key" => "value"
      },
    }
  end 

  context "when the selector finds a HashNode" do
    subject(:delete) { described_class.new("", "nested") }

    it "deletes the hash from the parent" do
      expect(delete.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [{"inside" => "value"}],
      })
    end
  end

  context "when the selector finds an ArrayNode" do
    subject(:delete) { described_class.new("array", "[inside=value]") }
    
    it "deletes the array from the parent" do
      expect(delete.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [],
        "nested" => {
          "key" => "value"
        },
      })
    end
  end

  context "when the selector matches multiple nodes" do
    subject(:delete) { described_class.new("array", "[inside=value]") }

    before { input_hash["array"] << {"inside" => "value"} }

    it "deletes all entries from the array" do
      expect(delete.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [],
        "nested" => {
          "key" => "value"
        },
      })
    end
  end
end
