module Flood
  class Data < Grape::API

    namespace :flood_data do

      desc 'Return a list of flood data'
      params do
        requires :limit, type: Integer, desc: 'The number of records to return', default: 1000
      end
      get do
        present FloodData.limit(params[:limit] || 1000).all
      end

    end

  end
end