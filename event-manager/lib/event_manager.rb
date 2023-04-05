require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

# Assignment: Clean Phone Numbers

def clean_phone(number)
  number.gsub!(/[^0-9]/, '')
  number.length == 10 || (number.length == 11 && number[0] == 1) ? number : 'Invalid number.'
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'Event Manager Initialized!'

template_letter = File.read('form_letter.erb')
erb_template = ERB.new(template_letter)

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  phone_number = clean_phone(row[:homephone])

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  puts phone_number

  save_thank_you_letter(id, form_letter)
end

# Assignment: Time Targeting

# start by creating empty hash with 0 as the default value
registration_hours = Hash.new(0)

# after that, we can get the registration hour by Time.now.hour
registration_hours[Time.now.hour] += 1

def peak_registration(hash)
  # get the highest values (occurence) from the key (hour)
  peak = hash.max_by { |_k, v| v }.first
  puts "The peak registration hour is at #{peak}."
end

peak_registration(registration_hours)

# Assignment: Day of the Week Targeting

# same as before
registration_days = Hash.new(0)

# but, instead of Time.now.hour, we use Time.now.strftime('%A') 
registration_days[Time.now.strftime('%A')] += 1

def peak_day(hash)
  peak = hash.max_by { |_k, v| v }.first

  puts "The peak registration day is on #{peak}."
end

peak_day(registration_days)