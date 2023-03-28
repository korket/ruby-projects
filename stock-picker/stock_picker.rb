def stock_picker(array)
  new_array = []

  array.reverse.each_with_index do |sell, day|
    list = []

    array.each do |buy|
      profit = sell - buy
      list.push(profit)
    end

    (day + 1).times do
      list.pop
    end

    new_array.push(list)
  end
  
  sell = new_array.find_index(new_array.max)
  buy = new_array.max.find_index(new_array.max.max)
  
  buy_and_sell = []
  buy_and_sell.push(buy)
  buy_and_sell.push(sell)

  p buy_and_sell
end

array = [17,3,6,9,15,8,6,1,10]

stock_picker(array)