require 'byebug'
require 'json'
require 'date'

require_relative 'src/models/car.rb'
require_relative 'src/models/rental.rb'
require_relative 'src/helpers/date_helper.rb'
require_relative 'src/services/json_file_generator.rb'
require_relative 'src/services/discount.rb'

class Main
  def self.run
    new.execute
  end

  attr_reader :input
  def initialize
    @input = JSON.parse(File.read("#{ENV['LEVEL']}data/input.json"), symbolize_names: true)
  end

  def execute
    JsonFileGenerator.run(
      filepath: "#{ENV['LEVEL']}data/output.json",
      content: { rentals: get_rentals }
    )
  end

  private

  def get_rentals
    input[:rentals].map do |rental|
      Rental.new(
        **rental.except(:car_id),
        car: get_cars.find{ |car| car.id == rental[:car_id] },
      ).to_hash
    end
  end

  def get_cars
    @cars ||= input[:cars].map { |car| Car.new(**car) }
  end
end
