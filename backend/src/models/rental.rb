class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance, :options
  def initialize(id:, car:, start_date:, end_date:, distance:, options:)
    @id = id
    @car = car
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @options = options
  end

  def to_hash
    {
      id: id,
    }.tap do |hash|
      if ENV['TRANSACTIONS'] == 'true'
        hash[:options] = options.map(&:type) if options
        hash[:actions] = transactions.map(&:to_hash)
      else
        hash[:price] = price
        hash[:commission] = commission.to_hash if ENV['COMMISSION'] == 'true'
      end
    end
  end

  def days
    @days ||= DateHelper.period_in_days(start_date, end_date)
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
      ['driver', 'debit', price + gps_price + baby_seat_price + additional_insurance_price],
      ['owner', 'credit', price - commission.total + gps_price + baby_seat_price],
      ['insurance', 'credit', commission.insurance_fee],
      ['assistance', 'credit', commission.assistance_fee],
      ['drivy', 'credit', commission.drivy_fee + additional_insurance_price]
    ].map do |who, type, amount|
      Transaction.new(who: who, type: type, amount: amount)
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

  def gps_price
    @gps ||= option_price('gps', 5)
  end

  def baby_seat_price
    @baby_seat ||= option_price('baby_seat', 2)
  end

  def additional_insurance_price
    @additional_insurance ||= option_price('additional_insurance', 10)
  end

  def option_price(type, price_per_day)
    return 0 unless options&.find{|option| option.type == type}

    price_per_day * 100 * days
  end
end
