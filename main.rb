require 'rubygems'
require 'pry'
require 'sinatra'
require 'active_record'
require 'active_support'
require 'pg'
require 'uri'
require 'date'

require_relative 'lib/fuzzy'
require_relative 'db/models'
require_relative 'db/load_ocr'

set :logging, true
require 'logger'
Dir.mkdir('logs') unless File.exist?('logs')
$log = Logger.new('logs/output.log','weekly')

configure :production do
  $log.level = Logger::WARN
end
configure :development do
  $log.level = Logger::DEBUG
end


get '/:date?/?:id?' do

  @date = params[:date].to_date unless params[:date].nil? || params[:date].empty?
  @event = Event.find(params[:id]) if params[:id]
  # Run tail -f logs/output.log to follow live logging
  $log.debug @date
  $log.debug @event
  erb :index
end

get '/events.json' do
  content_type :json
  sdate = DateTime.parse(params[:sdate])
  Event.future(sdate).to_json(:include => :location)
end

get '/locations.json' do
  content_type :json
  incomplete_text = CloseEnough::Fuzzy.digest(params[:term])
  Location.find_by_sql("SELECT * from locations where digested_name ilike '%#{incomplete_text}%';").map{ |x| {:id => x.id, :label => x.name , :value => x.name } }.to_json
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


post '/events/update/:id' do
  @event = Event.find(params[:id])
  
  @event.location = Location.find(params[:location_id]) if @event.location_id != params[:location_id]
  @event.band_name = params[:band_name]
  @event.start = params[:start] ? params[:start] : Date.today.strftime('%Y-%m-%d')
  
  @event.save
  redirect "/#{@event.start}/#{@event.id}"
end

