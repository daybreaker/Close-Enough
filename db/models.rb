require 'carrierwave'
require 'carrierwave/orm/activerecord'

class FlyerUploader < CarrierWave::Uploader::Base
  storage :file
end


ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :host     => '127.0.0.1',
  :username => 'postgres',
  :password => 'postgres',
  :database => 'close_enough',
  :encoding => 'utf8',
  :pool => 30
)


class Location < ActiveRecord::Base 
  set_table_name 'locations'
end

class Event < ActiveRecord::Base
  set_table_name 'events'
  mount_uploader :flyer, FlyerUploader
end
