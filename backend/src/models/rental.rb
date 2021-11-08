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
    }.tap do |hash|
      if ENV['TRANSACTIONS'] == 'true'
        hash[:actions] = transactions
      else
        hash[:price] = price
        hash[:commission] = commission.to_hash if ENV['COMMISSION'] == 'true'
      end
    end
  end

  def price
    @price ||= price_distance_component + price_time_component
  end

  def commission
    raise NotImplementedError unless ENV['COMMISSION'] == 'true'

    @commission ||= Commission.new(
      price: price,
      days: days
    )
  end

  def transactions
    raise NotImplementedError unless ENV['TRANSACTIONS'] == 'true'

    @transactions ||= [
      ['driver', 'debit', price],
      ['owner', 'credit', price - commission.total],
      ['insurance', 'credit', commission.insurance_fee],
      ['assistance', 'credit', commission.assistance_fee],
      ['drivy', 'credit', commission.drivy_fee]
    ].map do |who, type, amount|
      Transaction.new(who: who, type: type, amount: amount).to_hash
    end
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
    @days ||= DateHelper.period_in_days(start_date, end_date)
  end
end
