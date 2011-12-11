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
  
  @event.flyer.store!
  @event.location = CloseEnough::Ocr.locations_from_image(@event.flyer.current_path).first

  @event.save
  erb :event
end

