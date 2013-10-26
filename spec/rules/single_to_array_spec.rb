require 'transmogrifier'
require 'transmogrifier/rules/update_value'

describe Transmogrifier::Rules::SingleToArray do
  subject { described_class.new(key_name) }
  let(:key_name) { "key" }
  let(:match) { Transmogrifier::Match.new(nil, nil, input_hash, input_hash) }

  let(:input_hash) { { "key" => "value" } }
  let(:output_hash) {{ "key"=>["value"] }}

  it "puts the value in an array" do
    subject.apply!(match)

    expect(input_hash).to eq(output_hash)
  end
end
