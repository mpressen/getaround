class Discount
  def self.run(price_per_day:, days:)
    new(price_per_day, days).execute
  end

  attr_reader :price_per_day, :days
  def initialize(price_per_day, days)
    @price_per_day = price_per_day
    @days = days
  end

  def execute
    sum = 0

    days.times do |index|
      sum += get_discount_price_per_day(index + 1)
    end

    sum
  end

  private

  def get_discount_price_per_day(day)
    case day
    when 1
      price_per_day
    when 2..4
      price_per_day * 0.9
    when 5..10
      price_per_day * 0.7
    else
      price_per_day * 0.5
    end.to_i
  end
end
