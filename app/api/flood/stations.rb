module Flood
  class Stations < Grape::API

    namespace :stations do

      desc 'Return a list of stations'
      get do
        present Station.all
      end

      params do
        requires :postcode, type: String, desc: 'Postcode to find a station for'
      end
      get :postcode do
        service = AddressService.new
        present service.stations_for_postcode(params[:postcode]).first
      end

    end

  end
end