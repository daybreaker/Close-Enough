require 'rubygems'
require 'google_places'
require 'pry'
require 'active_record'

load 'db/models.rb'

@keys = ['AIzaSyC1_zHYlJSC8xp31vXWNhjWZj7lqwnZDi4']
@types = %w(art_gallery bar book_store bowling_alley cafe casino church library movie_theater restaurant place_of_worship night_club museum school shopping_mall stadium university zoo)

@main_types = %w(bar night_club stadium art_gallery cafe university)

@top = 30.034176
@left = -90.146566
@bottom = 29.908057
@right = -90.017084

@client = GooglePlaces::Client.new(@keys.sample(1).join)

l = []

(@bottom..@top).step( (@top - @bottom) / 100 ) do |lat|
  (@left..@right).step( (@right - @left) / 100 ) do |long|
    places = @client.spots(lat, long, :types => @main_types )
    places.each do |r|
      p = Location.new({
        :reference => r.reference,
        :vicinity => r.vicinity,
        :lat => r.lat,
        :lng => r.lng,
        :name => r.name,
        :icon => r.icon,
        :types => r.types,
        :gid => r.id,
        :formatted_phone_number => r.formatted_phone_number,
        :formatted_address => r.formatted_address,
        :address_components => r.address_components,
        :rating => r.rating,
        :url => r.url,
        :cid => r.cid
      })
      p.save
    end
  end
end


