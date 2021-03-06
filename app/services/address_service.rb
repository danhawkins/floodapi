require 'cgi/util'

class AddressService
  include HTTParty
  base_uri Rails.application.config.postcode_lookup_service_url

  # def initialize(service, page)
  #   @options = { :query => {:site => service, :page => page} }
  # end
  def resolve_postcode(postcode)
    postcode.gsub!(/\s/,'')
    Rails.logger.info("Searching for #{postcode}")
    response = self.class.get("/partial/#{postcode}")
    Rails.logger.info("Found #{response}")
    response
  end

  def stations_for_postcode(postcode)
    result = resolve_postcode(postcode)

    Station.where( :coordActual.near => [result['easting'], result['northing']])
  end

end