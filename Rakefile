require_relative 'main'
require 'sinatra/activerecord/rake'
require_relative 'places'
require_relative 'wwoz'

namespace :scrape do
  desc "Scrape Google Places"
  task :google_places do
    g = GooglePlaceGridSearch.new
    g.grid(5)
  end

  desc "Scrape WWOZ"
  task :wwoz do
    w = WWOZLivewire.new
    w.scrape
  end
  
end

namespace :util do

  desc "Digest location names"
  task :digest_names do
    Location.all.each { |l| l.digest_name; l.save  }
  end

end

