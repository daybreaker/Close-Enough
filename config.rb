require 'rubygems'
require 'google_places'
require 'pry'
require 'active_record'
require_relative 'db/models'
require_relative 'api_keys'

module CloseEnough
  module Config
    GooglePlaces = {
      :api_keys => APIKeys::GoogleKeys,
      :types => %w(art_gallery bar book_store bowling_alley cafe casino church library movie_theater restaurant place_of_worship night_club museum school shopping_mall stadium university zoo),
      :main_types => %w(bar night_club stadium art_gallery cafe university),
      :top => 30.034176,
      :left => -90.146566,
      :bottom => 29.908057,
      :right => -90.017084
    }

  end
end


