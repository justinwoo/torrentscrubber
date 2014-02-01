require "json"
require "selenium-webdriver"

secretfile = IO.read("secret.json")
secret = JSON.load(secretfile)
configfile = IO.read("config.json")
config = JSON.load(configfile)

url = secret["url"]
rpc = secret["rpc"]
shows = config["shows"]

driver = Selenium::WebDriver.for(:firefox)
driver.navigate.to(url)
elements = driver.find_elements(:css, 'tr.trusted.tlistrow > td.tlistname > a')
links = elements.map {
  |element|
  href = element.attribute("href")
  title = element.text
  [href, title]
}

# links.each_with_index {
#   |x, i|
#   puts "#{i}: #{x}"
# }

# IO.write("output.txt", JSON.pretty_generate(links))

# links.map { 
#   |link|
#   puts "link: #{link}"
#   driver.navigate.to(link)
#   date = driver.find_element(:css, '.vtop').text
#   puts "date #{date}"
# }


# output = JSON.pretty_generate(config)
# IO.write("config.json", output)
  