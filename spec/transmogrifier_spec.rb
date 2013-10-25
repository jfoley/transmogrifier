require "transmogrifier"

describe Transmogrifier::Engine do
  subject(:transmogrifier) { described_class.new }

  describe "renaming a key" do
    context "when the key is top level" do
      let(:input_hash) {{
        "key" => "value",
      }}

      let(:output_hash) {{
        "new_key" => "value",
      }}

      it "renames a key" do
        transmogrifier.add_rule(".", Transmogrifier::Rules::RenameKey.new("key", "new_key"))

        expect(transmogrifier.run(input_hash)).to eq(output_hash)
      end
    end

    context "when the key is nested" do
      let(:input_hash) {{
        "key" => { "nested" => "value"},
      }}

      let(:output_hash) {{
        "key" => { "new_key" => "value" },
      }}

      it "renames a key" do
        transmogrifier.add_rule("nested", Transmogrifier::Rules::RenameKey.new("nested", "new_key"))

        expect(transmogrifier.run(input_hash)).to eq(output_hash)
      end
    end

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
        transmogrifier.add_rule("nested", Transmogrifier::Rules::RenameKey.new("nested", "new_key"))

        expect(transmogrifier.run(input_hash)).to eq(output_hash)
      end
    end
  end

  describe "adding a key" do
    let(:input_hash) {{
      "key" => "value",
    }}

    let(:output_hash) {{
      "key" => "value",
      "new_key" => nil,
    }}

    it "adds a key with the value set to nil" do
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("new_key", nil))

      expect(transmogrifier.run(input_hash)).to eq(output_hash)
    end

    describe "when a default value is specified" do
      let(:output_hash) {{
        "key" => "value",
        "new_key" => "new_value",
      }}

      it "adds the key with the value set to default" do
        transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("new_key", "new_value"))

        expect(transmogrifier.run(input_hash)).to eq(output_hash)
      end
    end

    describe "when the given hash doesnt have intermediate keys" do
      it "it takes a selector and builds empty hashes along the way (aka: mkdir -p)" do
        output_hash = {
          "top" => {
            "next" => {
              "third" => { "deeply_nested" => nil },
            }
          }
        }

        transmogrifier.add_rule(".top.next.third", Transmogrifier::Rules::AddKey.new("deeply_nested", nil))

        expect(transmogrifier.run({})).to eq(output_hash)
      end
    end

    describe "when the key already exists" do
      it "raises"
    end
  end

  describe "deleting a key" do
    let(:input_hash) {{
      "key" => "value",
      "extra_key" => "value",
    }}

    let(:output_hash) {{
      "key" => "value",
    }}

    it "removes the key" do
      transmogrifier.add_rule(".", Transmogrifier::Rules::DeleteKey.new("extra_key"))

      expect(transmogrifier.run(input_hash)).to eq(output_hash)
    end
  end

  describe "transforming a value" do
    let(:input_hash) {{
      "key"=>"banana",
    }}

    let(:output_hash) {{
      "key"=>"monkey",
    }}

    it "transforms the value" do
      transmogrifier.add_rule(".", Transmogrifier::Rules::UpdateValue.new("key", "banana", "monkey"))

      expect(transmogrifier.run(input_hash)).to eq(output_hash)
    end
  end

  describe "rule ordering" do
    let(:output_hash) {{
      "key" => nil,
      "other_key" => "default",
      "transformed_key" => "default-transformed",
    }}

    it "applies rules in order" do
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("extra_key", nil))
      transmogrifier.add_rule(".", Transmogrifier::Rules::DeleteKey.new("extra_key"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("key", nil))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("other_key", "default"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("transformed_key", "default"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::UpdateValue.new("transformed_key", "default", "default-transformed"))

      expect(transmogrifier.run({})).to eq(output_hash)
    end
  end

  describe "nested rules" do

  end
end
