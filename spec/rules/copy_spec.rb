require "transmogrifier"

describe Transmogrifier::Rules::Copy do
  let(:input_hash) do
    {
      "key" => "value",
      "array" => [{"inside" => "value"}],
      "nested" => {
        "key" => "value",
      },
    }
  end

  context "when the selector finds a HashNode" do
    context "when the target key exists" do
      subject(:copy) { described_class.new("", "array.[inside=value]", "nested") }
      
      it "moves the hash to the to selector" do
        expect(copy.apply!(input_hash)).to eq({
          "key" => "value",
          "array" => [{"inside" => "value"}],
          "nested" => {
            "key" => "value",
            "inside" => "value",
          },
        })
      end
    end

    context "when the target key doesn't exist" do
      subject(:copy) { described_class.new("", "array.[inside=value]", "nested.nested_again") }

      it "moves the hash to a new child" do
        expect(copy.apply!(input_hash)).to eq({
          "key" => "value",
          "array" => [{"inside" => "value"}],
          "nested" => {
            "key" => "value",
            "nested_again" => {
              "inside" => "value",
            }
          },
        })
      end
    end

    context "when the from selector has a wildcard" do
      let(:input_hash) do
        {
          "list_of_things" => [
            {
              "name" => "object1",
              "property" => "property1",
              "nested" => {}
            },
            {
              "name" => "object2",
              "property" => "property2",
              "nested" => {}
            },
          ]
        }
      end
      subject(:copy) { described_class.new("list_of_things.[]", "property", "nested.property") }

      it "moves the matched hash to the correct place" do
        expect(copy.apply!(input_hash)).to eq({
          "list_of_things" => [
            {
              "name" => "object1",
              "property" => "property1",
              "nested" => { "property" => "property1" }
            },
            {
              "name" => "object2",
              "property" => "property2",
              "nested" => { "property" => "property2" }
            },
          ]
        })
      end
    end
  end

  context "when the selector finds an ArrayNode" do
    subject(:copy) { described_class.new("", "array", "nested.array") }

    it "moves the array to the to selector" do
      expect(copy.apply!(input_hash)).to eq({
        "key" => "value",
        "array" => [{"inside" => "value"}],
        "nested" => {
          "key" => "value",
          "array" => [{"inside" => "value"}],
        },
      })
    end
  end

  context "when the selector does not find a node" do
    context "when the parent node is a HashNode" do
      subject(:copy) { described_class.new("", "missing_key", "nested") }

      it "does not modify the input hash" do
        expect(copy.apply!(input_hash)).to eq(input_hash)
      end
    end

    context "when the parent node is an ArrayNode" do
      subject(:copy) { described_class.new("", "array.[inside=missing_value]", "nested") }

      it "does not modify the input hash" do
        expect(copy.apply!(input_hash)).to eq(input_hash)
      end
    end
  end
end
