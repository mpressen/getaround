class Car < Struct.new(:id, :price_per_day, :price_per_km, keyword_init: true)
end
