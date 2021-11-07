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
