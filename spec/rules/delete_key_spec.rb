require 'transmogrifier'
require 'transmogrifier/rules/delete_key'

describe Transmogrifier::Rules::DeleteKey do
  subject { described_class.new(key_name) }
  let(:key_name) { "extra_key" }
  let(:match) { Transmogrifier::Match.new(nil, nil, input_hash, input_hash) }
  let(:input_hash) { { "key" => "value", "extra_key" => "value" } }

  it "removes the key" do
    subject.apply!(match)

    expect(input_hash).to eq({ "key" => "value" })
  end

  it "raises if the given key isn't present in the match"
end
