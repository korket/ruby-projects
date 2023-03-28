def bubble_sort(array)
  (array.length-1).times do |a|
    swapped = false
    (array.length-a-1).times do |num|
      if array[num] > array[num+1]
        array[num], array[num+1] = array[num+1], array[num]
        swapped = true
      end
    end
    break if swapped != true
    p "#{a}. #{array}"
  end
  p array
end

array = [4,3,2,1,8,4,5,1,3,2,4,1]

bubble_sort(array)