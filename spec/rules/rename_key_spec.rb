require 'transmogrifier'
require 'transmogrifier/rules/rename_key'

describe Transmogrifier::Rules::RenameKey do
  subject { described_class.new(old_key_name, new_key_name) }
  let(:old_key_name) { "key" }
  let(:new_key_name) { "new_key" }
  let(:match) { Transmogrifier::Match.new(nil, nil, input_hash, input_hash) }
  let(:input_hash) { { "key" => "value" } }

  context "when the key is top level" do
    it "renames a key" do
      subject.apply!(match)

      expect(input_hash).to eq({ "new_key" => "value" })
    end
  end

  context "when the key is nested" do
    let(:input_hash) { {"key" => { "nested" => "value"} } }
    let(:old_key_name) { "nested" }
    let(:new_key_name) { "new_key" }
    let(:match) { Transmogrifier::Match.new("key", "nested", "value", input_hash["key"]) }

    it "renames a key" do
      subject.apply!(match)

      expect(input_hash).to eq({"key" => { "new_key" => "value" }})
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
      pending "this can't be tested this level"
      subject.apply!(match)

      expect(input_hash).to eq(output_hash)
    end
  end
end
