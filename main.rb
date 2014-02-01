require "json"
require "selenium-webdriver"
require "time"

secretfile = IO.read("secret.json")
secret = JSON.load(secretfile)
configfile = IO.read("config.json")
config = JSON.load(configfile)
url = secret["url"]
rpc = secret["rpc"]
shows = config["shows"]

def match_tags (title, tags)
    tag_matches = tags.map do |tag|
        title.include?(tag)
    end
    tags_matched = tag_matches.reduce do |first, second|
        if first == true and second == true
            true
        else
            false
        end
    end
    tags_matched
end

def grab_show (driver, show, rpc)
    href = driver.find_element(:css, 'div.viewdownloadbutton > a').attribute("href")
    driver.navigate.to(rpc)
    driver.find_element(:css, '#toolbar-open').click
    driver.find_element(:css, '#torrent_upload_url').send_keys(href)
    driver.find_element(:css, '#upload_confirm_button').click
    show["lastget"] = Time.now
end

driver = Selenium::WebDriver.for(:firefox)
driver.navigate.to(url)
elements = driver.find_elements(:css, 'tr.trusted.tlistrow > td.tlistname > a')
links = elements.map {
  |element|
  href = element.attribute("href")
  title = element.text
  [href, title]
}

links.each do |link|
    matched_shows = shows.select do |show|
        title = link[1]
        if title.include?(show["title"])
            tags = show["tags"]
            match_tags(title, tags)
        else
            false
        end
    end
    matched_shows.each do |show|
        url = link[0]
        driver.navigate.to(url)
        datetext = driver.find_element(:css, '.vtop').text
        date = Time.parse(datetext)
        lastget_text = show["lastget"]
        if lastget_text == ''
            grab_show(driver, show, rpc)
        else
            lastget = Time.parse(lastget_text)
            if lastget < date
                grab_show(driver, show, rpc)
            else
                puts "Already have the newest from #{link[1]}"
            end
        end
    end
end

new_config = JSON.pretty_generate(config)
IO.write('config.json', new_config)

driver.quit
