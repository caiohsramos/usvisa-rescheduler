# Account and current appointment info from https://ais.usvisa-info.com
# USERNAME = example@example.com
# PASSWORD = xxxxxxxxxx
# SCHEDULE_ID = 99999999
# MY_SCHEDULE_DATE = 2024-01-01
# ; Spanish - Colombia
# COUNTRY_CODE = es-co
# ; Bogotá
# FACILITY_ID = 25

# [CHROMEDRIVER]
# ; Details for the script to control Chrome
# LOCAL_USE = True
# ; Optional: HUB_ADDRESS is mandatory only when LOCAL_USE = False
# HUB_ADDRESS = http://localhost:9515/wd/hub

# [PUSHOVER]
# ; Get push notifications via https://pushover.net/ (optional)
# PUSH_TOKEN = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# PUSH_USER = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# [SENDGRID]
# ; Get email notifications via https://sendgrid.com/ (optional)
# SENDGRID_API_KEY =

require 'selenium-webdriver'
require 'date'
require_relative 'lib/us_visa_rescheduler'

DRIVER = Selenium::WebDriver.for :chrome
WAIT = Selenium::WebDriver::Wait.new(timeout: 60)
login = UsVisaRescheduler::Login.new(driver: DRIVER, username: 'caioramos97@gmail.com', password: '',
                                     wait: WAIT)
available_dates = UsVisaRescheduler::AvailableDates.new(driver: DRIVER, schedule_id: '44125405', location_id: '56')

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

  # if good date
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

  UsVisaRescheduler::Schedule.new(driver: DRIVER, schedule_id: '44125405', forms_info: [
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
