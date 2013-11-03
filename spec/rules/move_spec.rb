require "transmogrifier"

describe Transmogrifier::Rules::Move do
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
      subject(:move) { described_class.new("", "array.[inside=value]", "nested") }
      
      it "moves the hash to the to selector" do
        expect(move.apply!(input_hash)).to eq({
          "key" => "value",
          "array" => [],
          "nested" => {
            "key" => "value",
            "inside" => "value",
          },
        })
      end
    end

    context "when the target key doesn't exist" do
      subject(:move) { described_class.new("", "array.[inside=value]", "nested.nested_again") }

      it "moves the hash to a new child" do
        expect(move.apply!(input_hash)).to eq({
          "key" => "value",
          "array" => [],
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
      subject(:move) { described_class.new("list_of_things.[]", "property", "nested.property") }

      it "moves the matched hash to the correct place" do
        expect(move.apply!(input_hash)).to eq({
          "list_of_things" => [
            {
              "name" => "object1",
              "nested" => { "property" => "property1" }
            },
            {
              "name" => "object2",
              "nested" => { "property" => "property2" }
            },
          ]
        })
      end
    end
  end

  context "when the selector finds an ArrayNode" do
    subject(:move) { described_class.new("", "array", "nested.array") }

    it "moves the array to the to selector" do
      expect(move.apply!(input_hash)).to eq({
        "key" => "value",
        "nested" => {
          "key" => "value",
          "array" => [{"inside" => "value"}],
        },
      })
    end
  end

  context "using move as a rename" do
    subject(:rename) { described_class.new("", "array", "new_array") }

    it "renames the node" do
      expect(rename.apply!(input_hash)).to eq({
        "key" => "value",
        "new_array" => [{"inside" => "value"}],
        "nested" => {
          "key" => "value",
        },
      })
    end
  end
end
