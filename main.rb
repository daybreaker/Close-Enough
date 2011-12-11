require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'active_support'
require 'pg'
require 'uri'

require_relative 'db/models'
require_relative 'db/load_ocr'

get '/' do
  @locations = Location.all
  erb :index
end

get '/locations.json' do
  content_type :json
  Location.all.to_json
end

post '/flyers/new' do
  content_type :json
  event = Event.new
  event.flyer = params[:flyer_img][:tempfile]
  if event.save!
    { :response => 'SUCCESS', :img_url => event.flyer.url }.to_json 
  else
    { :response => 'FAIL', :message => "unable to save event" }.to_json
  end
end

post '/events/new' do 
  @post_data = params

  @event = Event.new
  @event.flyer = params[:flyer_img]

  @event.save!
  erb :event
end
