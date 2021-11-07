require_relative '../main.rb'

describe 'level1' do
  subject { File.read('level1/data/output.json') }
  let(:expected_output) { File.read('level1/data/expected_output.json') }

  before do
    ENV['LEVEL'] = 'level1/'
    Main.run
  end

  after do
    File.delete('level1/data/output.json')
  end

  it { is_expected.to eq expected_output }
end

describe 'level2' do
  subject { File.read('level2/data/output.json') }
  let(:expected_output) { File.read('level2/data/expected_output.json') }

  before do
    ENV['LEVEL'] = 'level2/'
    ENV['DISCOUNT'] = 'true'
    Main.run
  end

  after do
    File.delete('level2/data/output.json')
  end

  it { is_expected.to eq expected_output }
end

describe 'level3' do
  subject { File.read('level3/data/output.json') }
  let(:expected_output) { File.read('level3/data/expected_output.json') }

  before do
    ENV['LEVEL'] = 'level3/'
    ENV['DISCOUNT'] = 'true'
    ENV['COMMISSION'] = 'true'
    Main.run
  end

  after do
    File.delete('level3/data/output.json')
  end

  it { is_expected.to eq expected_output }
end
