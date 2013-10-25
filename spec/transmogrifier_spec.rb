require "transmogrifier"

describe Transmogrifier::Transmogrifier do
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

        expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
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

        expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
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

        expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
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

      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("new_key"))

      expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
    end

    describe "when a default value is specified" do
      let(:output_hash) {{
        "key" => "value",
        "new_key" => "default",
      }}

      it "adds the key with the value set to default" do
        transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("new_key", "default"))

        expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
      end
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

      expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
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
      transmogrifier.add_rule(".", Transmogrifier::Rules::TransformValue.new("key", "banana", "monkey"))

      expect(transmogrifier.transmogrify(input_hash)).to eq(output_hash)
    end
  end

  describe "rule ordering" do
    let(:output_hash) {{
      "key" => nil,
      "other_key" => "default",
      "transformed_key" => "default-transformed",
    }}

    it "applies rules in order" do
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("extra_key"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::DeleteKey.new("extra_key"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("key"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("other_key", "default"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::AddKey.new("transformed_key", "default"))
      transmogrifier.add_rule(".", Transmogrifier::Rules::TransformValue.new("transformed_key", "default", "default-transformed"))

      expect(transmogrifier.transmogrify({})).to eq(output_hash)
    end
  end

  describe "nested rules" do

  end
end
