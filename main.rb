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

elements.map { |x| puts x }


# output = JSON.pretty_generate(config)
# IO.write("config.json", output)
