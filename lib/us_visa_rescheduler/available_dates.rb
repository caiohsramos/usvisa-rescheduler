require 'json'
require 'date'

module UsVisaRescheduler
  class AvailableDates
    def initialize(driver:, schedule_id:, location_id:, consulate_id: nil, consulate_date: nil)
      @driver = driver
      @schedule_id = schedule_id
      @location_id = location_id
      @consulate_id = consulate_id
      @consulate_date = consulate_date
    end

    def all
      @consulate_id.nil? ? fetch_page : fetch_page_with_consulate_id
      content = @driver.find_element(:tag_name, 'pre').text
      JSON.parse(content).map { |item| Date.parse(item['date']) }
    end

    private

    def fetch_page
      @driver.get("https://ais.usvisa-info.com/pt-br/niv/schedule/#{@schedule_id}/appointment/days/#{@location_id}.json?appointments[expedite]=false")
    end

    def fetch_page_with_consulate_id
      @driver.get("https://ais.usvisa-info.com/pt-br/niv/schedule/#{@schedule_id}/appointment/days/#{@location_id}.json?consulate_id=#{@consulate_id}&consulate_date=#{@consulate_date}&consulate_time=9:00&appointments[expedite]=false")
    end
  end
end
