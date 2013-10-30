require "transmogrifier"

describe Transmogrifier::Engine do
  subject(:engine) { described_class.new }


  describe "appending keys" do
    let(:input_hash) {{
      "key" => "value",
      "array" => [],
    }}
    context "when the selector finds a HashNode" do
      before { engine.add_rule(:append, "", {"new_key" => "new_value"})}

      it "appends to the hash" do
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "array" => [],
          "new_key" => "new_value",
        })
      end
    end

    context "when the selector finds an ArrayNode" do
      before { engine.add_rule(:append, "array", {"new_key" => "new_value"})}

      it "appends to the array" do
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "array" => [{"new_key" => "new_value"}],
        })
      end
    end
  end

  describe "deleting keys" do
    let(:input_hash) {{
      "key" => "value",
      "array" => [{"inside" => "value"}],
      "nested" => {
        "key" => "value"
      },
    }}

    context "when the selector finds a HashNode" do
      before { engine.add_rule(:delete, "", "nested")}

      it "deletes the hash from the parent" do
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "array" => [{"inside" => "value"}],
        })
      end
    end

    context "when the selector finds an ArrayNode" do
      before { engine.add_rule(:delete, "array", "[inside=value]")}

      it "deletes the array from the parent" do
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "array" => [],
          "nested" => {
            "key" => "value"
          },
        })
      end
    end
  end

  describe "moving keys" do
    let(:input_hash) {{
      "key" => "value",
      "array" => [{"inside" => "value"}],
      "nested" => {
        "key" => "value",
      },
    }}

    context "when the selector finds a HashNode" do
      it "moves the hash to the to selector" do
        engine.add_rule(:move, "", "array.[inside=value]", "nested")
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "array" => [],
          "nested" => {
            "key" => "value",
            "inside" => "value",
          },
        })
      end

      it "moves the hash to a new child if the key doesn't exist" do
        engine.add_rule(:move, "", "array.[inside=value]", "nested.nested_again")

        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
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
      let(:input_hash) {{
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
      }}

      before { engine.add_rule(:move, "list_of_things.*", "property", "nested.property") }

      it "moves the matched hash to the correct place" do
        output_hash = engine.run(input_hash)

        expect(output_hash).to eq({
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

    context "when the selector finds an ArrayNode" do
      before { engine.add_rule(:move, "", "array", "nested.array") }

      it "moves the array to the to selector" do
        output_hash = engine.run(input_hash)
        expect(output_hash).to eq({
          "key" => "value",
          "nested" => {
            "key" => "value",
            "array" => [{"inside" => "value"}],
          },
        })
      end
    end

    context "using move as a rename" do
      before { engine.add_rule(:move, "", "array", "new_array") }

      it "renames the array" do
        output_hash = engine.run(input_hash)

        expect(output_hash).to eq({
          "key" => "value",
          "new_array" => [{"inside" => "value"}],
          "nested" => {
            "key" => "value",
          },
        })
      end
    end
  end
end
