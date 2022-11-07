require 'selenium-webdriver'
require 'date'
require_relative 'lib/us_visa_rescheduler'

DRIVER = Selenium::WebDriver.for :chrome
WAIT = Selenium::WebDriver::Wait.new(timeout: 60)
login = UsVisaRescheduler::Login.new(driver: DRIVER, username: '', password: '',
                                     wait: WAIT)
available_dates = UsVisaRescheduler::AvailableDates.new(driver: DRIVER, schedule_id: '', location_id: '56')

puts "\a"
login.perform

loop do
  dates = available_dates.all
  break if dates.empty?

  date = dates.first
  puts 'consulate date:'
  puts date
  puts
  if date > Date.new(2023, 3, 1)
    puts 'date not good. sleeping...'
    puts
    sleep(60)
    next
  end

  # Uncomment this check if you want to automatically input ASC date (poorly tested)
  # available_asc_dates = UsVisaRescheduler::AvailableDates.new(
  #   driver: DRIVER,
  #   schedule_id: '44125405',
  #   location_id: '60',
  #   consulate_id: '56',
  #   consulate_date: date.to_s
  # )
  # asc_date = available_asc_dates.all.first
  # puts 'ASC date:'
  # puts asc_date
  # puts

  # Enable automatic submit (poorly tested)
  UsVisaRescheduler::Schedule.new(submit: false, driver: DRIVER, schedule_id: '44125405', forms_info: [
                                    # Uncomment this check if you want to automatically input ASC date (poorly tested)
                                    # {
                                    #   date: asc_date,
                                    #   office: 'asc'
                                    # },
                                    {
                                      date:,
                                      office: 'consulate'
                                    }
                                  ]).perform

  puts 'scheduled!'
  10.times do
    puts "\a"
    sleep(0.3)
  end
  gets
  break
end
