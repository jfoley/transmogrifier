require "transmogrifier"

describe Transmogrifier::Engine do
  subject(:engine) { described_class.new }

  describe "renaming a key" do
    context "when the path has multiple matches" do
      let(:input_hash) {{
        "top_key" => { "nested" => "value"},
        "another" => { "nested" => "another"},
        "unrelated" => { "unchanged" => "the_same" },
      }}

      let(:output_hash) {{
        "top_key" => { "new_key" => "value"},
        "another" => { "new_key" => "another"},
        "unrelated" => { "unchanged" => "the_same" },
      }}

      it "renames a key" do
        engine.add_rule("nested", Transmogrifier::Rules::RenameKey.new("nested", "new_key"))

        expect(engine.run(input_hash)).to eq(output_hash)
      end
    end
  end

  describe "adding a key" do
    describe "when the given hash doesnt have intermediate keys" do
      it "it takes a selector and builds empty hashes along the way (aka: mkdir -p)" do
        output_hash = {
          "top" => {
            "next" => {
              "third" => { "deeply_nested" => nil },
            }
          }
        }

        engine.add_rule(".top.next.third", Transmogrifier::Rules::AddKey.new("deeply_nested", nil))

        expect(engine.run({})).to eq(output_hash)
      end
    end
  end

  describe "rule ordering" do
    let(:output_hash) {{
      "key" => nil,
      "other_key" => "default",
      "transformed_key" => "default-transformed",
    }}

    it "applies rules in order" do
      engine.add_rule(".", Transmogrifier::Rules::AddKey.new("extra_key", nil))
      engine.add_rule(".", Transmogrifier::Rules::DeleteKey.new("extra_key"))
      engine.add_rule(".", Transmogrifier::Rules::AddKey.new("key", nil))
      engine.add_rule(".", Transmogrifier::Rules::AddKey.new("other_key", "default"))
      engine.add_rule(".", Transmogrifier::Rules::AddKey.new("transformed_key", "default"))
      engine.add_rule(".", Transmogrifier::Rules::UpdateValue.new("transformed_key", "default", "default-transformed"))

      expect(engine.run({})).to eq(output_hash)
    end
  end

  describe "nested rules" do

  end

  describe "turning a key in to an array" do
    it "wraps the value in an array" do
      input_hash = { "key" => "value" }
      engine.add_rule(".", Transmogrifier::Rules::SingleToArray.new("key"))

      expect(engine.run(input_hash)).to eq({"key" => ["value"]})
    end
  end

  describe "demoting a key" do
    it "works" do
      input_hash = {
        "top_level" => [{
          "name" => "array_element",
        }],
        "sibling" => "demoted",
      }

      expected = {
        "top_level" => [{
          "name" => "array_element",
          "sibling" => "demoted",
        }],
      }
      engine.add_rule(".", Transmogrifier::Rules::DemoteKey.new("sibling", "array_element"))
      expect(engine.run(input_hash)).to eq(expected)
    end
  end
end
