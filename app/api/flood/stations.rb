module Flood
  class Stations < Grape::API

    namespace :stations do

      desc 'Return a list of stations'
      params do
        requires :limit, type: Integer, desc: 'The number of records to return', default: 1000
      end
      get do
        present Station.limit(params[:limit] || 1000).all
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