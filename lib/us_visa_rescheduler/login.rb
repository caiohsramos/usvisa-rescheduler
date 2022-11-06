module UsVisaRescheduler
  class Login
    def initialize(driver:, username:, password:, wait:)
      @driver = driver
      @username = username
      @password = password
      @wait = wait
    end

    def perform
      go_to_homepage
      sleep(0.5)
      click_down_arrow
      sleep(0.5)
      click_continue
      sleep(0.5)
      wait_for_commit
      click_down_arrow
      sleep(0.5)
      input_credentials
      click_privacy
      commit
      wait_for_continue
    end

    def logged_in?
      content = @driver.page_source
      !content.include?('error')
    end

    private

    def go_to_homepage
      @driver.get('https://ais.usvisa-info.com/pt-br/niv')
    end

    def click_down_arrow
      a = @driver.find_element(:xpath, '//a[@class="down-arrow bounce"]')
      a.click
    end

    def click_continue
      href = DRIVER.find_element(:xpath, '//*[@id="header"]/nav/div[2]/div[1]/ul/li[3]/a')
      href.click
    end

    def wait_for_commit
      @wait.until do
        @driver.find_element(:name, 'commit')
      end
    end

    def input_credentials
      user = @driver.find_element(:id, 'user_email')
      user.send_keys(@username)
      sleep(rand(1..3))
      pw = @driver.find_element(:id, 'user_password')
      pw.send_keys(@password)
      sleep(rand(1..3))
    end

    def click_privacy
      box = @driver.find_element(:class, 'icheckbox')
      box.click
      sleep(rand(1..3))
    end

    def commit
      btn = @driver.find_element(:name, 'commit')
      btn.click
      sleep(rand(1..3))
    end

    def wait_for_continue
      @wait.until do
        @driver.find_element(:xpath, "//a[contains(text(),'Continuar')]")
      end
    end
  end
end
