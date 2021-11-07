module JsonFileGenerator
  module_function

  def run(filepath:, content:)
    File.open(filepath, mode= 'w') do |f|
      f << JSON.pretty_generate(content) + "\n"
    end
  end
end
