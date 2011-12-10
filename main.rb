require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'pg'
require 'uri'

require_relative 'db/models'
require_relative 'db/load_locations'

get '/' do
  @locations = Location.all
  erb :index
end
