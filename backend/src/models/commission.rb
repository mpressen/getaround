class Commission
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee, :total
  def initialize(price:, days:)
    @price = price
    @days = days
  end

  def to_hash
    {
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    }
  end

  def insurance_fee
    @insurance_fee ||= (total / 2).to_i
  end

  def assistance_fee
    @assistance_fee ||= @days * 100
  end

  def drivy_fee
    @drivy_fee ||= total - insurance_fee - assistance_fee
  end

  def total
    @total ||= (@price * 0.3).to_i
  end
end
