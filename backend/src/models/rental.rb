class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance
  def initialize(id:, car:, start_date:, end_date:, distance:)
    @id = id
    @car = car
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
  end

  def to_hash
    {
      id: id,
      price: price
    }
  end

  def price
    price_distance_component + price_time_component
  end

  private

  def price_distance_component
    distance * car.price_per_km
  end

  def price_time_component
    if ENV['DISCOUNT']
      Discount.run(
        price_per_day: car.price_per_day,
        days: days
      )
    else
      days * car.price_per_day
    end
  end

  def days
    DateHelper.period_in_days(start_date, end_date)
  end
end
