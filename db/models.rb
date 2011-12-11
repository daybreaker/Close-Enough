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

  has_many :events
end

class Event < ActiveRecord::Base
  set_table_name 'events'

  belongs_to :location
  mount_uploader :flyer, FlyerUploader

  before_create :set_date

  # example:
  #    Event.future 3, :days
  #    Event.future 6, :hours
  #    Event.future :tonight
  def self.future(measure, unit=nil)
    end_dt = Time.now + 1.day

    case measure
    when Symbol
      case measure
      when :tongiht
        end_dt = Time.now.at_midnight + 2.hours
      end
    when Integer
      end_dt = Time.now + measure.send(unit)
    end

    self.starts_between(Time.now, end_dt)
  end

  def self.starts_between(dt1, dt2)
    self.find(:all, :conditions => { :start => dt1..dt2 })
  end

  private
    def set_date
      self.start = Time.now
      self.end = Time.now + 6.hours # 6 hour event
    end

end
