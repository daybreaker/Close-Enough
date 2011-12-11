module CloseEnough
  module Fuzzy
    extend self

    def digest(text)
      text.downcase.gsub(/[^a-z|\d]/, '')
    end
  end
end


