require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'active_support'
require 'pg'
require 'uri'

require_relative 'db/models'
require_relative 'db/load_locations'

configure do 
  set :public_folder, File.dirname(__FILE__) + '/public'
end

get '/' do
  @locations = Location.all
  erb :index
end

get '/locations.json' do
  content_type :json
  Location.all.to_json
end
