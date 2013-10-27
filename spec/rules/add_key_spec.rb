require 'transmogrifier'
require 'transmogrifier/rules/add_key'

describe Transmogrifier::Rules::AddKey do
  subject { described_class.new(key_name, default_value) }
  let(:key_name) { "new_key" }
  let(:default_value) { }
  let(:match) { Transmogrifier::Match.new(nil, nil, input_hash) }
  let(:input_hash) { { "key" => "value" } }

  it "adds a key with the value set to nil" do
    subject.apply!(match)

    expect(input_hash).to eq({
      "key" => "value",
      "new_key" => nil,
    })
  end

  describe "when a default value is specified" do
    let(:default_value) { "new_value" }

    it "adds the key with the value set to default" do
      subject.apply!(match)

      expect(input_hash).to eq({
        "key" => "value",
        "new_key" => "new_value",
      })
    end
  end
end
