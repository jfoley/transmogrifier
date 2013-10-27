require 'transmogrifier'
require 'transmogrifier/rules/update_value'

describe Transmogrifier::Rules::UpdateValue do
  subject { described_class.new(key_name, old_value, new_value) }
  let(:key_name) { "key" }
  let(:old_value) { "value" }
  let(:new_value) { "new_value" }
  let(:match) { Transmogrifier::Match.new(nil, nil, input_hash) }

  let(:input_hash) { { "key" => "value" } }
  let(:output_hash) {{ "key"=>"new_value" }}

  it "transforms the value" do
    subject.apply!(match)

    expect(input_hash).to eq(output_hash)
  end
end
