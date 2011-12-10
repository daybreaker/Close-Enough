require_relative 'config'

class GooglePlaceGridSearch
  def initialize
    CloseEnough::Config::GooglePlaces.each { |k, v| instance_variable_set("@"+k.to_s, v) }
    @client = GooglePlaces::Client.new(@api_keys.sample(1).join)  
  end
  
  def grid(steps)
    l = []
    (@bottom..@top).step( (@top - @bottom) / steps ) do |lat|
      (@left..@right).step( (@right - @left) / steps ) do |long|
        places = @client.spots(lat, long, :types => @main_types )
        places.each do |r|
          puts r.name + "\n"
          p = Location.new({
            :reference => r.reference,
            :vicinity => r.vicinity,
            :lat => r.lat,
            :lng => r.lng,
            :name => r.name,
            :icon => r.icon,
            :types => r.types,
            :gid => r.id,
            :formatted_phone_number => r.formatted_phone_number,
            :formatted_address => r.formatted_address,
            :address_components => r.address_components,
            :rating => r.rating,
            :url => r.url,
            :cid => r.cid
          })
          p.save unless Location.where(:gid => places.first.id).count > 0
        end
      end
    end
  end
  
  
end
