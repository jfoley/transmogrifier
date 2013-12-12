require "transmogrifier"

describe Transmogrifier::Rules::Update do
  let(:input_hash) do
    {
      "key" => "value",
      "hash" => { "nested" => "hash-value" },
      "array" => [{"name" => "array-value"}],
    }
  end

  context "when the key specifies a ValueNode" do
    subject(:update) { described_class.new("key", "new-value") }

    it "replaces the value with the new value" do
      expect(update.apply!(input_hash)).to eq({
        "key" => "new-value",
        "hash" => { "nested" => "hash-value" },
        "array" => [{"name" => "array-value"}],
      })
    end
  end

  context "when the key specifies a HashNode" do
    subject(:update) { described_class.new("hash", "new-value") }

    it "replaces the value of the hash with the new value" do
      expect(update.apply!(input_hash)).to eq({
          "key" => "value",
          "hash" => "new-value",
          "array" => [{"name" => "array-value"}],
      })
    end
  end

  context "when the key specifies an ArrayNode" do
    subject(:update) { described_class.new("array", "new-value") }

    it "replaces the value of the array with the new value" do
      expect(update.apply!(input_hash)).to eq({
          "key" => "value",
          "hash" => { "nested" => "hash-value" },
          "array" => "new-value",
      })
    end
  end

  context "when the selector specifies a node inside of an array" do
    let(:input_hash) do
      {
          "array" => [
            { "name" => "value-to-modify", "other" => "properties", "get" => "overwritten" },
            { "name" => "leave-me-alone" },
          ],
      }
    end

    subject(:update) { described_class.new("array.[name=value-to-modify]", { "name" => "new-value"}) }

    it "replaces the value of the array's node with the new value" do
      expect(update.apply!(input_hash)).to eq({
        "array" => [
          { "name" => "leave-me-alone" },
          { "name" => "new-value" },
        ],
      })
    end
  end

  context "when the selector does not find a node" do
    context "when the selector finds a hash as the parent" do
      subject(:update) { described_class.new("non-existent-key", "new-value") }

      it "raises a SelectorNotFoundError" do
        expect {
          update.apply!(input_hash)
        }.to raise_error(Transmogrifier::SelectorNotFoundError)
      end
    end

    context "when the selector finds an array as the parent" do
      subject(:update) { described_class.new("array.[name=non-existent-key]", "new-value") }

      it "raises a SelectorNotFoundError" do
        expect {
          update.apply!(input_hash)
        }.to raise_error(Transmogrifier::SelectorNotFoundError)
      end
    end

    context "when the selector does not find a parent" do
      subject(:update) { described_class.new("wrong.key", "new-value") }

      it "raises a SelectorNotFoundError" do
        expect {
          update.apply!(input_hash)
        }.to raise_error(Transmogrifier::SelectorNotFoundError)
      end
    end
  end
end
