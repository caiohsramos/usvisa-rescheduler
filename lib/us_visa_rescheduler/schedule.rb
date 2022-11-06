module UsVisaRescheduler
  class Schedule
    MONTHS = { 'January' => 1, 'February' => 2, 'March' => 3, 'April' => 4, 'May' => 5, 'June' => 6, 'July' => 7, 'August' => 8,
               'September' => 9, 'October' => 10, 'November' => 11, 'December' => 12 }.freeze

    def initialize(driver:, forms_info:, schedule_id:)
      @driver = driver
      @forms_info = forms_info # [{date:,office:asc/consulate}]
      @schedule_id = schedule_id
    end

    def perform
      go_to_appointment
      fill_forms
      # submit
    end

    private

    def go_to_appointment
      @driver.get("https://ais.usvisa-info.com/pt-br/niv/schedule/#{@schedule_id}/appointment")
      sleep(0.5)
    end

    def fill_forms
      @forms_info.each do |info|
        sleep(0.5)
        date_input = @driver.find_element(:id, "appointments_#{info[:office]}_appointment_date")
        date_input.click

        select_date(info[:date])
        sleep(0.5)

        # load times
        sleep(2)

        time_select = Selenium::WebDriver::Support::Select.new(@driver.find_element(:id,
                                                                                    "appointments_#{info[:office]}_appointment_time"))
        time_select.select_by(:index, 1)
      end
    end

    def submit
      reschedule_btn = @driver.find_element(:id, 'appointments_submit')
      reschedule_btn.click

      confirm_btn = @driver.find_element(:css, 'a.button.alert')
      confirm_btn.click
    end

    def select_date(date)
      sleep(0.5)
      month = @driver.find_element(:css,
                                   '#ui-datepicker-div > .ui-datepicker-group-first .ui-datepicker-month')&.text
      month = MONTHS[month]
      year = @driver.find_element(:css,
                                  '#ui-datepicker-div > .ui-datepicker-group-first .ui-datepicker-year')&.text&.to_i
      expected_month = date.month
      expected_year = date.year
      tries = 0

      loop do
        break if tries >= 24 || (month == expected_month && year == expected_year)

        next_button = @driver.find_element(:css, '.ui-datepicker-next.ui-corner-all')
        next_button.click
        month = @driver.find_element(:css,
                                     '#ui-datepicker-div > .ui-datepicker-group-first .ui-datepicker-month')&.text
        month = MONTHS[month]

        year = @driver.find_element(:css,
                                    '#ui-datepicker-div > .ui-datepicker-group-first .ui-datepicker-year')&.text&.to_i
        tries += 1
      end

      if tries == 24
        print('Could not find expected month/year')
        return false
      end

      day_button = @driver.find_element(:xpath, "//a[text()=\"#{date.day}\"]")
      day_button.click
    end
  end
end
