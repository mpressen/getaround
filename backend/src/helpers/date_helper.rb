module DateHelper
  module_function

  def period_in_days(start_date, end_date)
    (end_date - start_date).to_i + 1
  end
end
