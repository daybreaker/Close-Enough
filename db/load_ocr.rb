require 'close_enough_ocr'

locations = Location.all

warn "Didn't get any locations" unless locations.any?

CloseEnough::Ocr.load_locations! locations

