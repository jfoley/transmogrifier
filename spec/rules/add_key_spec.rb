require 'transmogrifier'
require 'transmogrifier/rules/add_key'

describe Transmogrifier::Rules::AddKey do
  subject { described_class.new(new_key, new_value) }
  let(:new_key) { "new_key" }
  let(:new_value) { "new_value" }

  context "when the parent is nil" do
    let(:input_hash) { { "key" => "value" } }
    let(:match) { Transmogrifier::Match.new(nil, nil, input_hash) }

    it "adds a key with the given value" do
      subject.apply!(match)

      expect(input_hash).to eq({
        "key" => "value",
        "new_key" => "new_value",
      })
    end
  end

  context "when the parent is not nil" do
    let(:input_hash) { {"top_level" => {"nested" => "value"}} }
    let(:match) { Transmogrifier::Match.new(input_hash, "top_level", input_hash["top_level"]) }

    it "adds a key with the value set to nil" do
      subject.apply!(match)

      expect(input_hash).to eq({
        "top_level" => {
          "nested" => "value",
          "new_key" => "new_value",
        },
      })
    end
  end
end
