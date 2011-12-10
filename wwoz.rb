require 'open-uri'
require 'nokogiri'
require 'pry'

urls = []
(0..15).each do |x|
  urls << "http://www.wwoz.org/new-orleans-community/music-venues?page=" + x.to_s
end

url = urls.first #for testing only
#urls.each do |url|
  venues_html = Nokogiri::HTML(open(url))
  venues =  venues_html.css('div.view-content div.item-list ul li.views-row span.field-content a')
  
  venues.each do |venue|
    puts venue.text + "\n"
    vurl = 'http://www.wwoz.org' + venue.attributes['href'].value
    Nokogiri::HTML(open(url))
  end
