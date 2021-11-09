module JsonFileGenerator
  module_function

  def run(filepath:, content:)
    File.open(filepath, mode= 'w') do |f|
      f << format_json(content)
    end
  end

  private

  def self.format_json(content)
    result = JSON.pretty_generate(content)

    # #pretty_generate does format 'key : []' as 'key: [
    #
    #                                            ]'
    result.gsub!(/\[\n\n\s+\]/, "[]")

    # files end with a new line
    result + "\n"
  end
end
