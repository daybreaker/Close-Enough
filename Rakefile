require_relative 'main'
require 'sinatra/activerecord/rake'
require_relative 'places'

namespace :scrape do
  desc "Scrape Google Places"
  task :google_places do
    g = GooglePlaceGridSearch.new
    g.grid(5)
  end

  
end
