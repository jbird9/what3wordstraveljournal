# what3wordstraveljournal
#This program will take data from google locations json files and uses 
#the what3words API create a fancy haiku about your journey. Don't 
#expect the haiku to make sense, but do expect your enemies to
#trianglate your position.


#You will need to provide your own JSON file from 
#https://takeout.google.com/settings/takeout. Select location history
#and send the file to yourself.

#USAGE:

ruby 3wordTravelJournal.rb /PATH_TO/LocationHistory.json > lat_long_words.html

#Then use the haiku generator code from 
#https://github.com/Paurian/EULA-haiku-generator-Using-Ruby which should
#already be in your github library.

ruby EULA-haiku-generator-Using-Ruby/new_test_haiku.rb lat_long_words.html

#Enjoy your haiku. Reflect on it. You are the world.
