#!/usr/bin/ruby

require 'curl'
w3wkey = "BHBTANZT"
lat = ARGV[0]
long = ARGV[1]

url = "www.google.com"
puts lat
puts long
url = "https://api.what3words.com/v2/reverse?coords=#{lat}%2C#{long}&key=#{w3wkey}&lang=en&format=json&display=full"

url_str = "\'#{url}\'"
#puts url_str
puts `curl --request GET --url #{url_str}`
