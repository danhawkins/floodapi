module Flood
  class Data < Grape::API

    namespace :flood_data do

      desc 'Return a list of flood data'
      params do
        requires :stationReference
        optional :start, type: Date
        optional :end, type: Date
        optional :group, type: String, desc: 'The grouping type', values: ['day', 'week', 'month', 'year'], default: 'day'
        optional :type, type: String, desc: 'The data type', values: ['Flow', 'Rainfall', 'Water Level', 'Wind']
        optional :historic, type: Boolean, desc: 'Use historic data'
      end
      get do 
        data = (params[:historic] ? FloodDataHistoric : FloodData).aggregate(params)
        data.each do |row|
          row.merge!(row.delete('_id'))
        end
        present data
      end

    end

  end
end