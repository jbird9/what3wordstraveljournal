#!/usr/bin/ruby

require 'curl'
require 'json'

w3wkey = "BHBTANZT"

jsonfile = File.read(ARGV[0])
data_hash = JSON.parse(jsonfile)

#lat = ARGV[0]
#long = ARGV[1]

url = "www.google.com"
#puts lat
#puts long
#url = "https://api.what3words.com/v2/reverse?coords=#{lat}%2C#{long}&key=#{w3wkey}&lang=en&format=json&display=full"

url_str = "\'#{url}\'"
#puts url_str
#puts `curl --request GET --url #{url_str}`

lats = []
longs = []
locs = data_hash["locations"]
#puts locs.length
(0..locs.length-1).each do |i|
	lats << locs[i]["latitudeE7"]
	longs << locs[i]["longitudeE7"]	
end

(0..locs.length-1).each do |j|
	url = "https://api.what3words.com/v2/reverse?coords=#{lats[j].to_s.insert(-8,'.')}%2C#{longs[j].to_s.insert(-8,'.')}&key=#{w3wkey}&lang=en&format=json&display=full"
	url_str = "\'#{url}\'"
	puts `curl --request GET --url #{url_str}`
end
