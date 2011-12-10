require 'rubygems'
require 'google_places'
require 'pry'
require 'active_record'

load 'db/models.rb'

@keys = ['AIzaSyC1_zHYlJSC8xp31vXWNhjWZj7lqwnZDi4','AIzaSyDCEhOTsxuuXVPsHbA4rPofhK1azdoF7-M']
@types = %w(art_gallery 
bar
book_store
bowling_alley
cafe
casino
church
library
movie_theater
restaurant
place_of_worship
night_club
museum
school
shopping_mall
stadium
university
zoo
)

@main_types = %w(bar night_club stadium art_gallery cafe university)

@top = 30.034176
@left = -90.146566
@bottom = 29.908057
@right = -90.017084

@client = GooglePlaces::Client.new(@keys.sample(1).join)

l = []

(@bottom..@top).step( (@top - @bottom) / 100 ) do |lat|
  (@left..@right).step( (@right - @left) / 100 ) do |long|
    #@client.spots(lat, long, :types => @main_types )
    l << [lat,long]
  end
end

r = @client.spots(l[4678][0], l[3400][1], :types => @types )

binding.pry
    

