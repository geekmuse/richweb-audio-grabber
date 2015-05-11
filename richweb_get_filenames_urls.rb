require "selenium-webdriver"
require "stringex_lite"

wait = Selenium::WebDriver::Wait.new(:timeout => 15)


d = Selenium::WebDriver.for :chrome, :prefs => prefs
d.navigate.to "https://therichwebexperience.com/n/login/view"

uname = d.find_element(:id, "j_username")
uname.send_keys "my_username"

pword = d.find_element(:id, "j_password")
pword.send_keys "my_password"

login = d.find_element(:css, "input.submit")
login.click

d.navigate.to "https://therichwebexperience.com/n/alumni/presentationrecording/list?showId=349"

audio_links = d.find_elements(:css => "td.presentation h4 a")
audio_links = audio_links.map { |a| a.attribute("href") }

file_urls = Hash.new
i = 1
audio_links.each { |a|
  d.navigate.to a
  sleep 5
  audio_tag = d.find_element(:css => "#jp_audio_0")

  if !(audio_tag == "")
    if (audio_tag.attribute("src") != "")
      file_urls[i.to_s + "_" + d.find_element(:css => "div.presentation-recording h1").text.to_url] = audio_tag.attribute("src")
    else
      puts d.find_element(:css => "div.presentation-recording h1").text
    end
  end

  i += 1
}


file_urls.each do |title, link|
  puts "#{title}::#{link}"
end

d.quit
