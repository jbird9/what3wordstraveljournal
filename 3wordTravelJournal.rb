#!/usr/bin/ruby

require 'curl'
require 'json'
require 'lingua'
require 'facets'

w3wkey = "BHBTANZT"

jsonfile = File.read(ARGV[0])
data_hash = JSON.parse(jsonfile)

collect_locations = 120

lats = []
longs = []
locs = data_hash["locations"]
#puts locs.length
(0..locs.length-1).each do |i|
	lats << locs[i]["latitudeE7"]
	longs << locs[i]["longitudeE7"]	
end

lats_longs = lats.zip(longs).to_h

#words = []
puts '<lines title="what3wordstraveljournalhaiku" provider="google_location" software="what3words" src="user_provide">'

words = []
syllable_len = []
collect_locations.times do
	rand_loc = rand(0..lats_longs.length-1)
	url = "https://api.what3words.com/v2/reverse?coords=#{lats_longs.keys[rand_loc].to_s.insert(-8,'.')}%2C#{lats_longs.values[rand_loc].to_s.insert(-8,'.')}&key=#{w3wkey}&lang=en&format=json&display=full"
	url_str = "\'#{url}\'"
	jsonout = `curl --request GET --url #{url_str}`
	data_hash1 = JSON.parse(jsonout)
	words << data_hash1["words"].split('.').join(' ')
	syllable_len << Lingua::EN::Syllable.syllables(data_hash1["words"].split('.').join(' '))
end

word_syl = words.zip(syllable_len).to_h

(0..word_syl.length-1).each do |k|
	ran_key = word_syl.keys.sample
	if (word_syl["#{ran_key}"] == 5) || (word_syl["#{ran_key}"] == 7) then
		print "\t"
		print '<line syllables="'
		print word_syl["#{ran_key}"]
		print '" text="'
		print "#{ran_key}"
		print '" paragraph="'
		print "#{k}"
		print '" />'
		print "\n"
	end
	word_syl = word_syl.except(:ran_key)
end

#puts words
