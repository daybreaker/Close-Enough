require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'pg'
require 'uri'

load 'db/models.rb'


get '/' do
  @locations = Location.all
  erb :index
end
