require 'open-uri'
require 'nokogiri'
require 'pry'
require_relative 'config'

class WWOZLivewire
  
  def initialize
    @api_keys = CloseEnough::Config::GooglePlaces[:api_keys]
    @client = GooglePlaces::Client.new(@api_keys.sample(1).join)  
  end

  def scrape 
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
        venue_details_html = Nokogiri::HTML(open(vurl)).css('div.node')
        status = venue_details_html.css('.venue-status').text.downcase.include?("open") ? 'open' : 'closed'
        address = venue_details_html.css('.street-address').text + " " + venue_details_html.css('.locality').text + ', ' +  venue_details_html.css('.region').text
        map_matches = /q=(.*?)\+(.*?)\+/.match (venue_details_html.css('.location.map-link a').select{|x| x.text == "Google Maps" }.first.attributes['href'].value)
        lat, long = map_matches[1..2]
        
        #places = @client.spots(lat, long, :name => venue.text )
        
        l = Location.new({
          :vicinity => address,
          :lat => lat,
          :lng => long,
          :status => status,
          :from_wwoz => 1,
          :name => venue.text
        })
        
        l.save
        
      end
    #end
  end
  
end
