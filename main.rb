require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'active_support'
require 'pg'
require 'uri'

require_relative 'db/models'
require_relative 'db/load_ocr'
require_relative 'lib/fuzzy'

get '/' do
  erb :index
end

get '/events.json' do
  content_type :json
  Event.future(:tonight).to_json(:include => :location)
end

post '/locations.json' do
  content_type :json
  incomplete_text = CloseEnough::Fuzzy.digest(params[:q])
  Location.find_by_sql("SELECT * from locations where digested_name ilike '%#{incomplete_text}%';").to_json
end

post '/events/new' do 
  @post_data = params

  @event = Event.new
  @event.flyer = params[:flyer_img]
  
  @event.flyer.store!
  @event.location = CloseEnough::Ocr.locations_from_image(@event.flyer.current_path).first
  
  @event.save
  erb :event
end

post '/events/update' do
  @event = Event.find(params[:event_id])
  
  @event.location = Location.find(params[:location_id]) if @event.location_id != params[:location_id]
  @event.band_name = params[:band_name]
  @event.start = params[:start]
  
  @event.save
  redirect '/'
end

