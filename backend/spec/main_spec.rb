shared_examples "create proper file" do
  let(:output) { File.read("#{ENV['LEVEL']}data/output.json") }
  let(:expected_output) { File.read("#{ENV['LEVEL']}data/expected_output.json") }

  before do
    ENV['LEVEL'] = "#{subject}/"
    %x[ruby "#{ENV['LEVEL']}main.rb"]
  end

  after do
    File.delete("#{ENV['LEVEL']}data/output.json")
  end

  it { expect(output).to eq expected_output }
end

describe 'level1' do
  include_examples "create proper file"
end

describe 'level2' do
  include_examples "create proper file"
end

describe 'level3' do
  include_examples "create proper file"
end

describe 'level4' do
  include_examples "create proper file"
end

describe 'level5' do
  include_examples "create proper file"
end
