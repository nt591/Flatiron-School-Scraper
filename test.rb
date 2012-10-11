require 'sqlite3'
require 'nokogiri'
require 'open-uri'

index_url = 'http://students.flatironschool.com/index.html'
index_doc = Nokogiri::HTML(open(index_url))

puts index_doc.xpath("//div[@class='one_third'][1]//a/@href")
