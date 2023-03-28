# require 'pry-byebug'

def substrings(string, list)

  # binding.pry

  new_string = string.downcase.split(' ')
  new_list = Hash.new(0)
  
  new_string.each do |substring|
    list.each do |list_substring|
      if substring.include?(list_substring)
        new_list[list_substring] += 1
      end
    end
  end
  puts new_list
end


dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

substrings("below", dictionary)
substrings("Howdy partner, sit down! How's it going?", dictionary)