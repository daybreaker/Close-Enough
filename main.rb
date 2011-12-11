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


get '/' do
  @date = params[:date].to_date unless params[:date].nil? || params[:date].empty?
  @event = Event.find(params[:id]) if params[:id]
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
  
  $log.debug @event.flyer
  @event.location = CloseEnough::Ocr.locations_from_image(@event.flyer.current_path).first
  
  @event.save
  erb :event
end


post '/events/update/:id' do
  @event = Event.find(params[:id])
  
  @event.location = Location.find(params[:location_id]) if @event.location_id != params[:location_id]
  @event.band_name = params[:band_name]
  params[:start_time] ||= ''
  @event.start = !(params[:start_date].nil? || params[:start_date].empty?)  ? params[:start_date] + ' ' + params[:start_time] : Time.now
  
  @event.save
  redirect "/?date=#{@event.start.strftime('%Y-%m-%d')}&id=#{@event.id}"
end

