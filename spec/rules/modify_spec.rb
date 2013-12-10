require "transmogrifier"

describe Transmogrifier::Rules::Modify do
  let(:input_hash) do
    { "key" => "value", "array" => [] }
  end

  context "when the selector finds a ValueNode" do
    subject(:modify) { described_class.new("key", "al", "og") }

    it "modifies the value" do
      expect(modify.apply!(input_hash)).to eq({
        "key" => "vogue",
        "array" => [],
      })
    end
  end

  context "when the selector finds a HashNode" do
    subject(:modify) { described_class.new("", "al", "og") }

    it "raises an error" do
      expect{modify.apply!(input_hash)}.to raise_error(NotImplementedError)
    end
  end

  context "when the selector finds an ArrayNode" do
    subject(:modify) { described_class.new("array", "al", "og") }

    it "raises an error" do
      expect{modify.apply!(input_hash)}.to raise_error(NotImplementedError)
    end
  end
end
